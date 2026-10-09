// CropOcr.cs —— 通过 WinRT COM ABI 调用系统自带 Windows.Media.Ocr，对扫描页面做中文 OCR。
// 不依赖 winsdk / tesseract / 网络。
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

namespace CropOcr
{
    internal static class Wrt
    {
        [DllImport("combase.dll", CharSet = CharSet.Unicode, ExactSpelling = true)]
        private static extern int RoGetActivationFactory(IntPtr activatableClassId, ref Guid iid, out IntPtr factory);

        [DllImport("combase.dll", CharSet = CharSet.Unicode, ExactSpelling = true)]
        private static extern int WindowsCreateString(string sourceString, int length, out IntPtr hstring);

        [DllImport("combase.dll", CharSet = CharSet.Unicode, ExactSpelling = true)]
        internal static extern int WindowsDeleteString(IntPtr hstring);

        [DllImport("combase.dll", CharSet = CharSet.Unicode, ExactSpelling = true)]
        private static extern int WindowsGetStringRawBuffer(IntPtr hstring, out IntPtr buffer);

        [UnmanagedFunctionPointer(CallingConvention.StdCall)]
        private delegate int SlotDelegate(IntPtr self, IntPtr a, IntPtr b, IntPtr c, IntPtr d, IntPtr e, IntPtr f);

        private static IntPtr Slot(IntPtr obj, int index)
        {
            return Marshal.ReadIntPtr(Marshal.ReadIntPtr(obj), IntPtr.Size * index);
        }

        internal static int Call(IntPtr obj, int index, IntPtr a, IntPtr b, IntPtr c, IntPtr d, IntPtr e, IntPtr f)
        {
            SlotDelegate del = (SlotDelegate)Marshal.GetDelegateForFunctionPointer(Slot(obj, index), typeof(SlotDelegate));
            return del(obj, a, b, c, d, e, f);
        }

        internal static void Check(int hr, string what)
        {
            if (hr < 0)
            {
                throw new COMException(what + " hr=0x" + hr.ToString("X8"), hr);
            }
        }

        internal static IntPtr HString(string s)
        {
            IntPtr h;
            Check(WindowsCreateString(s, s.Length, out h), "WindowsCreateString");
            return h;
        }

        internal static IntPtr Factory(string className, string iid)
        {
            Guid g = new Guid(iid);
            IntPtr h = HString(className);
            try
            {
                IntPtr f;
                int hr = RoGetActivationFactory(h, ref g, out f);
                if (hr < 0)
                {
                    throw new COMException("RoGetActivationFactory(" + className + ") hr=0x" + hr.ToString("X8"), hr);
                }
                return f;
            }
            finally
            {
                WindowsDeleteString(h);
            }
        }

        /// <summary>
        /// 等待 IAsyncOperation 完成并取回结果接口指针。
        /// IAsyncOperation 的 ABI: 0-2=IInspectable, 3=SetCompleted, 4=get_Status(Int32), 5=get_ErrorCode, 6=GetResults, 7=Cancel
        /// 这里用轮询 get_Status 的方式，避免自建 WinRT 委托对象。
        /// </summary>
        internal static IntPtr Await(IntPtr op)
        {
            if (op == IntPtr.Zero)
            {
                throw new InvalidOperationException("IAsyncOperation 指针为空");
            }

            IntPtr statusBuf = Marshal.AllocHGlobal(4);
            try
            {
                DateTime deadline = DateTime.UtcNow.AddSeconds(180);
                int status;
                do
                {
                    Marshal.WriteInt32(statusBuf, 0);
                    Check(Call(op, 4, statusBuf, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero), "IAsyncOperation.get_Status");
                    status = Marshal.ReadInt32(statusBuf);
                    if (status == 1)
                    {
                        break;
                    }
                    if (status != 0)
                    {
                        throw new COMException("IAsyncOperation 失败，状态=" + status, status);
                    }
                    System.Threading.Thread.Sleep(10);
                }
                while (DateTime.UtcNow < deadline);

                if (status == 0)
                {
                    throw new TimeoutException("OCR 异步操作等待超时");
                }
            }
            finally
            {
                Marshal.FreeHGlobal(statusBuf);
            }

            IntPtr buf = Marshal.AllocHGlobal(IntPtr.Size);
            try
            {
                Marshal.WriteIntPtr(buf, IntPtr.Zero);
                Check(Call(op, 6, buf, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero), "IAsyncOperation.GetResults");
                return Marshal.ReadIntPtr(buf);
            }
            finally
            {
                Marshal.FreeHGlobal(buf);
                Marshal.Release(op);
            }
        }

        /// <summary>调用 (HSTRING, out 接口指针) 形式的方法。</summary>
        internal static IntPtr CallHStringInPtrOut(IntPtr obj, int slot, IntPtr hstr)
        {
            IntPtr outPtr;
            int hr = CallHStringInPtrOutEx(obj, slot, hstr, out outPtr);
            Check(hr, "call hstring slot=" + slot);
            return outPtr;
        }

        /// <summary>同上，但返回 HRESULT 而不是抛异常，便于诊断。</summary>
        internal static int CallHStringInPtrOutEx(IntPtr obj, int slot, IntPtr hstr, out IntPtr result)
        {
            IntPtr buf = Marshal.AllocHGlobal(IntPtr.Size);
            try
            {
                Marshal.WriteIntPtr(buf, IntPtr.Zero);
                int hr = Call(obj, slot, hstr, buf, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero);
                result = Marshal.ReadIntPtr(buf);
                return hr;
            }
            finally
            {
                Marshal.FreeHGlobal(buf);
            }
        }

        internal static int QueryInterface(IntPtr obj, string iid, out IntPtr result)
        {
            Guid g = new Guid(iid);
            return Marshal.QueryInterface(obj, ref g, out result);
        }

        /// <summary>调用返回接口指针的方法。</summary>
        internal static IntPtr CallPtr(IntPtr obj, int slot, params IntPtr[] args)
        {
            IntPtr buf = Marshal.AllocHGlobal(IntPtr.Size);
            try
            {
                Marshal.WriteIntPtr(buf, IntPtr.Zero);
                IntPtr a = args.Length > 0 ? args[0] : IntPtr.Zero;
                IntPtr b = args.Length > 1 ? args[1] : IntPtr.Zero;
                Check(Call(obj, slot, a, b, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero), "call slot=" + slot);
                return Marshal.ReadIntPtr(buf);
            }
            finally
            {
                Marshal.FreeHGlobal(buf);
            }
        }

        /// <summary>调用返回接口指针、且带一个接口参数的方法（参数在前，返回值在后）。</summary>
        internal static IntPtr CallPtr1(IntPtr obj, int slot, IntPtr arg)
        {
            IntPtr buf = Marshal.AllocHGlobal(IntPtr.Size);
            try
            {
                Marshal.WriteIntPtr(buf, IntPtr.Zero);
                Check(Call(obj, slot, arg, buf, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero), "call slot=" + slot);
                return Marshal.ReadIntPtr(buf);
            }
            finally
            {
                Marshal.FreeHGlobal(buf);
            }
        }

        internal static unsafe double CallDouble(IntPtr obj, int slot)
        {
            double buf = 0;
            Check(Call(obj, slot, (IntPtr)(&buf), IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero), "call double slot=" + slot);
            return buf;
        }

        internal static IntPtr GetProperty(IntPtr obj, int slot)
        {
            return CallPtr(obj, slot);
        }

        internal static int GetInt32Property(IntPtr obj, int slot)
        {
            int buf = 0;
            unsafe
            {
                Check(Call(obj, slot, (IntPtr)(&buf), IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero), "get int32 slot=" + slot);
            }
            return buf;
        }

        internal static bool GetBoolProperty(IntPtr obj, int slot)
        {
            byte buf = 0;
            unsafe
            {
                Check(Call(obj, slot, (IntPtr)(&buf), IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero), "get bool slot=" + slot);
            }
            return buf != 0;
        }

        internal static string ReadHString(IntPtr h)
        {
            if (h == IntPtr.Zero)
            {
                return string.Empty;
            }
            IntPtr buf;
            try
            {
                int hr = WindowsGetStringRawBuffer(h, out buf);
                if (hr < 0 || buf == IntPtr.Zero)
                {
                    return string.Empty;
                }
                int len = 0;
                while (Marshal.ReadInt16(buf, len * 2) != 0)
                {
                    len++;
                }
                return Marshal.PtrToStringUni(buf, len);
            }
            finally
            {
                WindowsDeleteString(h);
            }
        }
    }

    public sealed class OcrLine
    {
        public string Text;
    }

    public static class Ocr
    {        // 本机 Windows.Foundation 元数据中读取到的接口 IID
        private const string IID_STORAGE_FILE_STATICS = "5984c710-daf2-43c8-8bb4-a4d3eacfd03f";
        private const string IID_OCR_ENGINE_STATICS = "5bffa85a-3384-3540-9940-699120d428a8";
        private const string IID_OCR_ENGINE = "5a14bc41-5b76-3140-b680-8825562683ac";
        private const string IID_LANGUAGE_FACTORY = "9b0252ac-0c27-44f8-b792-9793fb66c63e";
        private const string IID_LANGUAGE = "ea79a752-f7c2-4265-b1bd-c4dec4e4f080";
        private const string IID_OCR_RESULT = "9bd235b2-175b-3d6a-92e2-388c206e2f63";
        private const string IID_OCR_LINE = "0043a16f-e31f-3a24-899c-d444bd088124";
        private const string IID_BITMAP_DECODER_STATICS = "438ccb26-bcef-4e95-bad6-23a822e58d01";
        private const string IID_ITERABLE_LINE = "7c926437-4228-2648-9a35-c2b6e1b8e3b4";
        private const string IID_ITERATOR_LINE = "7c926437-4228-2648-9a35-c2b6e1b8e3b5";

        // vtable 槽位（IInspectable 占 0-5，之后按 IDL 声明顺序）
        private const int SLOT_STORAGE_GET_FILE = 6;   // IStorageFileStatics.GetFileFromPathAsync
        private const int SLOT_STORAGE_OPEN = 6;       // IStorageFile.OpenAsync
        private const int SLOT_DECODER_CREATE = 6;     // IBitmapDecoderStatics.CreateAsync
        private const int SLOT_DECODER_BITMAP = 10;    // IBitmapDecoder.GetSoftwareBitmapAsync
        private const int SLOT_LANG_CREATE = 6;        // ILanguageFactory.CreateLanguage
        // IOcrEngineStatics: 6=get_MaxImageDimension 7=get_AvailableRecognizerLanguages
        //                    8=IsLanguageSupported 9=TryCreateFromLanguage 10=TryCreateFromUserProfileLanguages
        private const int SLOT_ENGINE_TRY = 9;         // IOcrEngineStatics.TryCreateFromLanguage
        private const int SLOT_ENGINE_RECOGNIZE = 6;   // IOcrEngine.RecognizeAsync
        private const int SLOT_RESULT_LINES = 6;       // IOcrResult.get_Lines
        private const int SLOT_LINE_TEXT = 6;          // IOcrLine.get_Text
        private const int SLOT_ITERABLE_FIRST = 6;     // IIterable<T>.First
        private const int SLOT_ITERATOR_CURRENT = 6;   // IIterator<T>.get_Current
        private const int SLOT_ITERATOR_HASCURRENT = 7; // IIterator<T>.get_HasCurrent
        private const int SLOT_ITERATOR_MOVENEXT = 8;  // IIterator<T>.MoveNext
        private const int SLOT_VECTORVIEW_SIZE = 7;    // IVectorView<T>.get_Size

        /// <summary>识别单张图片，返回按行文本；fullText 输出整页文本。</summary>
        public static List<OcrLine> Recognize(string imagePath, string languageTag, out string fullText)
        {
            List<OcrLine> lines = new List<OcrLine>();
            fullText = string.Empty;

            IntPtr fileStatics = IntPtr.Zero;
            IntPtr engineStatics = IntPtr.Zero;
            IntPtr languageFactory = IntPtr.Zero;
            IntPtr decoderStatics = IntPtr.Zero;
            IntPtr file = IntPtr.Zero;
            IntPtr language = IntPtr.Zero;
            IntPtr engine = IntPtr.Zero;
            IntPtr stream = IntPtr.Zero;
            IntPtr bitmap = IntPtr.Zero;
            IntPtr decoder = IntPtr.Zero;
            IntPtr result = IntPtr.Zero;

            try
            {
                fileStatics = Wrt.Factory("Windows.Storage.StorageFile", IID_STORAGE_FILE_STATICS);
                engineStatics = Wrt.Factory("Windows.Media.Ocr.OcrEngine", IID_OCR_ENGINE_STATICS);
                languageFactory = Wrt.Factory("Windows.Globalization.Language", IID_LANGUAGE_FACTORY);
                decoderStatics = Wrt.Factory("Windows.Graphics.Imaging.BitmapDecoder", IID_BITMAP_DECODER_STATICS);

                // Language（ILanguageFactory：0-5 为 IInspectable，6=CreateLanguage(String, out Language)）
                IntPtr hTag = Wrt.HString(languageTag);
                try
                {
                    IntPtr hLang = Wrt.CallHStringInPtrOut(languageFactory, SLOT_LANG_CREATE, hTag);
                    if (hLang != IntPtr.Zero)
                    {
                        Wrt.Check(Wrt.QueryInterface(hLang, IID_LANGUAGE, out language), "QI ILanguage");
                        Marshal.Release(hLang);
                    }
                }
                finally
                {
                    Wrt.WindowsDeleteString(hTag);
                }
                if (language == IntPtr.Zero)
                {
                    throw new InvalidOperationException("创建语言对象失败: " + languageTag);
                }

                // OcrEngine.TryCreateFromLanguage
                engine = Wrt.CallPtr1(engineStatics, SLOT_ENGINE_TRY, language);
                if (engine == IntPtr.Zero)
                {
                    throw new InvalidOperationException("系统未安装 " + languageTag + " 的 OCR 语言包");
                }

                // StorageFile.GetFileFromPathAsync
                IntPtr hPath = Wrt.HString(System.IO.Path.GetFullPath(imagePath));
                IntPtr op;
                try
                {
                    op = Wrt.CallPtr1(fileStatics, SLOT_STORAGE_GET_FILE, hPath);
                }
                finally
                {
                    Wrt.WindowsDeleteString(hPath);
                }
                file = Wrt.Await(op);

                // IStorageFile.OpenAsync(FileAccessMode.Read = 0)
                stream = Wrt.Await(Wrt.CallPtr1(file, SLOT_STORAGE_OPEN, IntPtr.Zero));

                // BitmapDecoder.CreateAsync(stream)
                decoder = Wrt.Await(Wrt.CallPtr1(decoderStatics, SLOT_DECODER_CREATE, stream));

                // IBitmapDecoder.GetSoftwareBitmapAsync()
                bitmap = Wrt.Await(Wrt.CallPtr(decoder, SLOT_DECODER_BITMAP));

                // IOcrEngine.RecognizeAsync(bitmap)
                result = Wrt.Await(Wrt.CallPtr1(engine, SLOT_ENGINE_RECOGNIZE, bitmap));

                // 整页文本（IOcrResult: IInspectable(3) + get_Lines(6) + get_TextAngle(7) + get_Text(8)）
                fullText = Wrt.ReadHString(Wrt.GetProperty(result, 8));

                // Lines（IVectorView: IInspectable(3) + IIterable.First(6) + get_Size(7) + GetAt(8)）
                IntPtr lineView = Wrt.GetProperty(result, SLOT_RESULT_LINES);
                try
                {
                    int count = Wrt.GetInt32Property(lineView, SLOT_VECTORVIEW_SIZE);
                    IntPtr iter = Wrt.CallPtr(lineView, SLOT_ITERABLE_FIRST);
                    try
                    {
                        for (int i = 0; i < count; i++)
                        {
                            IntPtr lineObj = Wrt.CallPtr(iter, SLOT_ITERATOR_CURRENT);
                            try
                            {
                                OcrLine line = new OcrLine();
                                line.Text = Wrt.ReadHString(Wrt.GetProperty(lineObj, SLOT_LINE_TEXT));
                                lines.Add(line);
                            }
                            finally
                            {
                                Marshal.Release(lineObj);
                            }

                            if (i + 1 < count)
                            {
                                if (!Wrt.GetBoolProperty(iter, SLOT_ITERATOR_HASCURRENT))
                                {
                                    break;
                                }
                                bool moved;
                                unsafe
                                {
                                    byte buf = 0;
                                    Wrt.Check(Wrt.Call(iter, SLOT_ITERATOR_MOVENEXT, (IntPtr)(&buf), IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero), "IIterator.MoveNext");
                                    moved = buf != 0;
                                }
                                if (!moved)
                                {
                                    break;
                                }
                            }
                        }
                    }
                    finally
                    {
                        Marshal.Release(iter);
                    }
                }
                finally
                {
                    Marshal.Release(lineView);
                }

                return lines;
            }
            finally
            {
                if (result != IntPtr.Zero) Marshal.Release(result);
                if (decoder != IntPtr.Zero) Marshal.Release(decoder);
                if (bitmap != IntPtr.Zero) Marshal.Release(bitmap);
                if (stream != IntPtr.Zero) Marshal.Release(stream);
                if (file != IntPtr.Zero) Marshal.Release(file);
                if (engine != IntPtr.Zero) Marshal.Release(engine);
                if (language != IntPtr.Zero) Marshal.Release(language);
                if (decoderStatics != IntPtr.Zero) Marshal.Release(decoderStatics);
                if (fileStatics != IntPtr.Zero) Marshal.Release(fileStatics);
                if (engineStatics != IntPtr.Zero) Marshal.Release(engineStatics);
                if (languageFactory != IntPtr.Zero) Marshal.Release(languageFactory);
            }
        }
    }
}
