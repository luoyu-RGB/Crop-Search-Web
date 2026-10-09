using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.Text;

/// <summary>
/// 使用 Windows.Media.Ocr 对页面图片进行中文 OCR。
/// 全部通过反射调用 WinRT API，编译时不需要 WinMD 引用。
/// 输出每页的纯文本与带坐标的行/词 JSON，便于还原字段和表格结构。
/// </summary>
internal static class OcrTool
{
    private static Type WinRt(string name)
    {
        Type t = Type.GetType(name + ", Windows.Foundation, ContentType=WindowsRuntime", false);
        if (t == null)
        {
            throw new InvalidOperationException("无法解析 WinRT 类型: " + name);
        }
        return t;
    }

    private static readonly MethodInfo AsTaskMethod = FindAsTask();

    private static MethodInfo FindAsTask()
    {
        Type ext = typeof(System.WindowsRuntimeSystemExtensions);
        foreach (MethodInfo m in ext.GetMethods(BindingFlags.Public | BindingFlags.Static))
        {
            if (m.Name == "AsTask" && !m.IsGenericMethodDefinition && m.GetParameters().Length == 1)
            {
                return m;
            }
        }
        throw new MissingMethodException("System.WindowsRuntimeSystemExtensions.AsTask(IAsyncAction)");
    }

    private static object Await(object op)
    {
        object task = AsTaskMethod.Invoke(null, new object[] { op });
        task.GetType().GetMethod("Wait", Type.EmptyTypes).Invoke(task, null);
        return task.GetType().GetProperty("Result").GetValue(task, null);
    }

    private static object Invoke(Type type, object target, string method, object[] args)
    {
        MethodInfo mi = null;
        foreach (MethodInfo m in type.GetMethods(BindingFlags.Public | BindingFlags.Static | BindingFlags.Instance))
        {
            if (m.Name != method)
            {
                continue;
            }
            ParameterInfo[] ps = m.GetParameters();
            if (ps.Length != args.Length)
            {
                continue;
            }
            bool ok = true;
            for (int i = 0; i < ps.Length; i++)
            {
                if (args[i] != null && !ps[i].ParameterType.IsInstanceOfType(args[i]))
                {
                    ok = false;
                    break;
                }
            }
            if (ok)
            {
                mi = m;
                break;
            }
        }
        if (mi == null)
        {
            throw new MissingMethodException(type.FullName + "." + method);
        }
        return mi.Invoke(target, args);
    }

    private static object Prop(object target, string name)
    {
        return target.GetType().GetProperty(name).GetValue(target, null);
    }

    private static string Esc(string s)
    {
        if (s == null)
        {
            return string.Empty;
        }
        StringBuilder sb = new StringBuilder(s.Length + 8);
        foreach (char c in s)
        {
            switch (c)
            {
                case '"': sb.Append("\\\""); break;
                case '\\': sb.Append("\\\\"); break;
                case '\r': break;
                case '\n': sb.Append("\\n"); break;
                case '\t': sb.Append("\\t"); break;
                default:
                    sb.Append(c < 0x20 ? ' ' : c);
                    break;
            }
        }
        return sb.ToString();
    }

    private static string Num(object v)
    {
        return Convert.ToDouble(v, CultureInfo.InvariantCulture).ToString("0.##", CultureInfo.InvariantCulture);
    }

    private static int Main(string[] args)
    {
        if (args.Length < 2)
        {
            Console.Error.WriteLine("用法: OcrTool.exe <图片文件或目录> <输出目录> [languageTag]");
            return 2;
        }

        string input = Path.GetFullPath(args[0]);
        string outDir = Path.GetFullPath(args[1]);
        string tag = args.Length > 2 ? args[2] : "zh-Hans-CN";
        Directory.CreateDirectory(outDir);

        List<string> files = new List<string>();
        if (Directory.Exists(input))
        {
            files.AddRange(Directory.GetFiles(input, "page-*.png"));
            files.Sort(StringComparer.OrdinalIgnoreCase);
        }
        else
        {
            files.Add(input);
        }
        if (files.Count == 0)
        {
            Console.Error.WriteLine("没有找到待识别图片: " + input);
            return 3;
        }

        Type storageFileT = WinRt("Windows.Storage.StorageFile");
        Type fileAccessModeT = WinRt("Windows.Storage.FileAccessMode");
        Type bitmapDecoderT = WinRt("Windows.Graphics.Imaging.BitmapDecoder");
        Type ocrEngineT = WinRt("Windows.Media.Ocr.OcrEngine");
        Type languageT = WinRt("Windows.Globalization.Language");

        object language = Activator.CreateInstance(languageT, new object[] { tag });
        object engine = Invoke(ocrEngineT, null, "TryCreateFromLanguage", new object[] { language });
        if (engine == null)
        {
            Console.Error.WriteLine("无法创建 OCR 引擎，语言: " + tag);
            return 4;
        }

        object readMode = Enum.Parse(fileAccessModeT, "Read");

        foreach (string file in files)
        {
            try
            {
                object storageFile = Await(Invoke(storageFileT, null, "GetFileFromPathAsync", new object[] { file }));
                object stream = Await(Invoke(storageFileT, storageFile, "OpenAsync", new object[] { readMode }));
                object decoder = Await(Invoke(bitmapDecoderT, null, "CreateAsync", new object[] { stream }));
                object bitmap = Await(Invoke(bitmapDecoderT, decoder, "GetSoftwareBitmapAsync", new object[0]));
                object result = Await(Invoke(ocrEngineT, engine, "RecognizeAsync", new object[] { bitmap }));

                StringBuilder json = new StringBuilder();
                json.Append("{\"page\":\"").Append(Esc(Path.GetFileNameWithoutExtension(file))).Append("\",\"lines\":[");
                StringBuilder plain = new StringBuilder();
                bool firstLine = true;
                int lineCount = 0;

                foreach (object line in (IEnumerable)Prop(result, "Lines"))
                {
                    string text = (string)Prop(line, "Text");
                    plain.AppendLine(text);

                    if (!firstLine)
                    {
                        json.Append(',');
                    }
                    firstLine = false;
                    lineCount++;

                    json.Append("{\"text\":\"").Append(Esc(text)).Append("\",\"words\":[");
                    bool firstWord = true;
                    foreach (object word in (IEnumerable)Prop(line, "Words"))
                    {
                        object rect = Prop(word, "BoundingRect");
                        if (!firstWord)
                        {
                            json.Append(',');
                        }
                        firstWord = false;
                        json.Append("{\"t\":\"").Append(Esc((string)Prop(word, "Text")))
                            .Append("\",\"x\":").Append(Num(Prop(rect, "X")))
                            .Append(",\"y\":").Append(Num(Prop(rect, "Y")))
                            .Append(",\"w\":").Append(Num(Prop(rect, "Width")))
                            .Append(",\"h\":").Append(Num(Prop(rect, "Height")))
                            .Append('}');
                    }
                    json.Append("]}");
                }

                json.Append("],\"lineCount\":").Append(lineCount.ToString(CultureInfo.InvariantCulture)).Append('}');

                string baseName = Path.GetFileNameWithoutExtension(file);
                File.WriteAllText(Path.Combine(outDir, baseName + ".json"), json.ToString(), new UTF8Encoding(false));
                File.WriteAllText(Path.Combine(outDir, baseName + ".txt"), plain.ToString(), new UTF8Encoding(false));

                Console.WriteLine(baseName + " lines=" + lineCount.ToString(CultureInfo.InvariantCulture));

                IDisposable d1 = bitmap as IDisposable;
                if (d1 != null) { d1.Dispose(); }
                IDisposable d2 = stream as IDisposable;
                if (d2 != null) { d2.Dispose(); }
            }
            catch (Exception ex)
            {
                Exception e = ex is TargetInvocationException && ex.InnerException != null ? ex.InnerException : ex;
                Console.Error.WriteLine("FAILED " + Path.GetFileName(file) + ": " + e.GetType().Name + ": " + e.Message);
                return 5;
            }
        }

        return 0;
    }
}
