// Probe.cs —— 逐步诊断 WinRT OCR 调用链，打印每一步的 HRESULT 与指针。
using System;
using System.Runtime.InteropServices;

namespace CropOcr
{
    public static class Probe
    {
        public static string Run(string languageTag)
        {
            System.Text.StringBuilder log = new System.Text.StringBuilder();
            ProbeDiag.Dump(languageTag, log);
            return log.ToString();
        }
    }

    internal static class ProbeDiag
    {
        private const string IID_STORAGE_FILE_STATICS = "5984c710-daf2-43c8-8bb4-a4d3eacfd03f";
        private const string IID_OCR_ENGINE_STATICS = "5bffa85a-3384-3540-9940-699120d428a8";
        private const string IID_LANGUAGE_FACTORY = "9b0252ac-0c27-44f8-b792-9793fb66c63e";
        private const string IID_LANGUAGE = "ea79a752-f7c2-4265-b1bd-c4dec4e4f080";
        private const string IID_UNKNOWN = "00000000-0000-0000-c000-000000000046";

        internal static void Dump(string tag, System.Text.StringBuilder log)
        {
            IntPtr p;
            int hr;

            p = TryFactory("Windows.Globalization.Language", IID_LANGUAGE_FACTORY, log);
            if (p != IntPtr.Zero)
            {
                IntPtr hTag = Wrt.HString(tag);
                IntPtr outPtr;
                hr = Wrt.CallHStringInPtrOutEx(p, 6, hTag, out outPtr);
                log.AppendLine("CreateLanguage hr=0x" + hr.ToString("X8") + " lang=" + outPtr.ToString("X"));
                Wrt.WindowsDeleteString(hTag);
                if (outPtr != IntPtr.Zero)
                {
                    IntPtr lang;
                    hr = Wrt.QueryInterface(outPtr, IID_LANGUAGE, out lang);
                    log.AppendLine("QI(ILanguage) hr=0x" + hr.ToString("X8"));
                    if (lang != IntPtr.Zero)
                    {
                        IntPtr hStr = Wrt.GetProperty(lang, 6);
                        log.AppendLine("LanguageTag=" + Wrt.ReadHString(hStr));
                        Marshal.Release(lang);
                    }
                    Marshal.Release(outPtr);
                }
                Marshal.Release(p);
            }

            IntPtr engStatics = TryFactory("Windows.Media.Ocr.OcrEngine", IID_OCR_ENGINE_STATICS, log);
            log.AppendLine("engine statics=" + engStatics.ToString("X"));
            if (engStatics != IntPtr.Zero)
            {
                Marshal.Release(engStatics);
            }

            TryFactory("Windows.Storage.StorageFile", IID_STORAGE_FILE_STATICS, log).ToString();
        }

        private static IntPtr TryFactory(string cls, string iid, System.Text.StringBuilder log)
        {
            try
            {
                IntPtr f = Wrt.Factory(cls, iid);
                log.AppendLine("factory(" + cls + ")=OK " + f.ToString("X"));
                return f;
            }
            catch (Exception ex)
            {
                log.AppendLine("factory(" + cls + ") FAILED: " + ex.Message);
                return IntPtr.Zero;
            }
        }
    }
}
