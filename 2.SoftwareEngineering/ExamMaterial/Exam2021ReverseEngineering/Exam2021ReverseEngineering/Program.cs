using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.IO;
using System.IO.Ports;
namespace DataStorageApp
{
    class Program
    {
        static void Main(string[] args)
        {
            new ProgramStart();
        }
    }
    class ProgramStart
    {
        LayerData rLayerData;
        LayerBusiness rLayerBusiness;
        LayerUser rLayerUser;
        public ProgramStart()
        {
            try
            {
                rLayerData = new LayerData();
                rLayerBusiness = new LayerBusiness(rLayerData);
                rLayerUser = new LayerUser(rLayerBusiness);
                rLayerUser.MainLoop();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error starting application: " + ex.Message);
            }
        }
    }
    public class LayerData
    {
        SerialPort rSerialPort;
        bool bOpenPort;

public bool Open(string sPortName, out string sOpenMsg)
        {
            if (bOpenPort == true)
            {
                Close();
            }
            try
            {
                rSerialPort = new SerialPort(sPortName, 4800, Parity.None, 8, StopBits.One);
                rSerialPort.ReadTimeout = 500;
                rSerialPort.WriteTimeout = 500;
                rSerialPort.Open();
                sOpenMsg = "Open <" + sPortName + "> serial port OK!";
                bOpenPort = true;
            }
            catch (Exception e)
            {
                sOpenMsg = "Error open <" + sPortName + "> serial port: " + e.Message;
                bOpenPort = false;
            }
            return bOpenPort;
        }
        // Not used
        //public string WaitRead(int iCntMax, int iSleep, int iMaxLoop, bool bTimeoutMsg,
        //out bool bRxTimeout)
        //{
        //    int iCnt = 0;
        //    string sRxMsg = "";
        //    bRxTimeout = false;
        //    while (iCnt < iMaxLoop)
        //    {
        //        Thread.Sleep(iSleep);
        //        sRxMsg = sRxMsg + Read(iCntMax, bTimeoutMsg);
        //        if (sRxMsg.Length >= iCntMax)
        //        {
        //            iCnt = iMaxLoop;
        //            bRxTimeout = false;
        //        }
        //        else
        //        {
        //            iCnt++;
        //        }
        //    }
        //    return sRxMsg;
        //}
        public string EmptyReadBuffer(int iMaxSize, int iWaitLoops, int iWaitTime)
        {
            int iRxMax, iRxLen, iCntLoop, iOffset;
            string sMsgBuf;
            byte[] bMsgBuf;
            iCntLoop = 0;
            iOffset = 0;
            try
            {
                bMsgBuf = new byte[iMaxSize + 16]; // Add some extra bytes to buffer
                sMsgBuf = "";
                while (iCntLoop < iWaitLoops)
                {
                    
                Thread.Sleep(iWaitTime);
                    if ((iRxMax = rSerialPort.BytesToRead) > (iMaxSize - iOffset))
                    {
                        iRxMax = (iMaxSize - iOffset);
                    }
                    if (iRxMax > 0)
                    {
                        iRxLen = rSerialPort.Read(bMsgBuf, iOffset, iRxMax);
                        iOffset += iRxLen;
                    }
                    if (iOffset >= iMaxSize)
                    {
                        iCntLoop = iWaitLoops;
                    }
                    else
                    {
                        iCntLoop++;
                    }
                }
                sMsgBuf = Encoding.Default.GetString(bMsgBuf);
            }
            catch (Exception e)
            {
                sMsgBuf = "<ErrorSerialPort=" + e.Message + ">";
            }
            return sMsgBuf;
        }
        //Not used
        //public string Read(int iCntMax, bool bTimeoutMsg)
        //{
        //    int iLen, iMsgCnt, iOffset, iMaxLoop;
        //    string sMsgBuf;
        //    byte[] bMsgBuf;
        //    iLen = 0;
        //    sMsgBuf = "";
        //    try
        //    {
        //        bMsgBuf = new byte[iCntMax + 16];
        //        iOffset = 0;
        //        try
        //        {
        //            iMaxLoop = 0;
        //            while (iOffset < iCntMax && iMaxLoop < 64)
        //            {
        //                iLen = rSerialPort.Read(bMsgBuf, iOffset, (bMsgBuf.Length - iOffset));
        //                iOffset += iLen;
        //                iMaxLoop++;
        //            }
        //            for (iMsgCnt = 0; iMsgCnt < iOffset; iMsgCnt++)
        //            {
        //                sMsgBuf = sMsgBuf + Convert.ToChar(bMsgBuf[iMsgCnt]);
        //            }
        //        }
        //        catch (TimeoutException)
        //        {
        //            if (iOffset > 0)
        //            {
        //                for (iMsgCnt = 0; iMsgCnt < iOffset; iMsgCnt++)
                            
        //            {
        //                    sMsgBuf = sMsgBuf + Convert.ToChar(bMsgBuf[iMsgCnt]);
        //                }
        //                if (bTimeoutMsg == true)
        //                {
        //                    sMsgBuf = sMsgBuf + "<Timeout>";
        //                }
        //            }
        //        }
        //        catch (Exception e)
        //        {
        //            sMsgBuf = sMsgBuf + "<Exception=" + e.Message + ">";
        //        }
        //    }
        //    catch (Exception e)
        //    {
        //        sMsgBuf = sMsgBuf + "<Serial port error=" + e.Message + ">";
        //    }
        //    return sMsgBuf;
        //}
        public void Close()
        {
            if (bOpenPort == true)
            {
                rSerialPort.Close();
                bOpenPort = false;
            }
        }
        public bool ChkOpen
        {
            get
            {
                return bOpenPort;
            }
        }

        //Not Used
        //public void UpdateLogCsvFile(string sFileName, double[] dVals, out string sErrMsg)
        //{
        //    string sMsg;
        //    int iCntr;
        //    TextWriter rLogFile;
        //    if (dVals.Length > 0)
        //    {
        //        sMsg = DateTime.Now.ToString("dd-MMM-yyy;HH:mm:ss");
        //        for (iCntr = 0; iCntr < dVals.Length; iCntr++)
        //        {
        //            sMsg = sMsg + "; " + dVals[iCntr].ToString("F1");
        //        }
        //        try
        //        {
        //            rLogFile = new StreamWriter(sFileName, true);
        //            rLogFile.WriteLine(sMsg);
        //            rLogFile.Close();
        //            sErrMsg = "";
        //        }
        //        catch (Exception ex)
        //        {
        //            sErrMsg = "Err: Writing log file <" + sFileName + ">: " +
                   
        //        ex.Message;
        //        }
        //    }
        //    else
        //    {
        //        sErrMsg = "Err: No writing to log file <" + sFileName +
        //        ">: Empty value buffer";
        //    }
        //}
        //public void HeaderLogCvsFile(string sFilename, string[] sHeader, out string sErrMsg)
        //{
        //    string sMsg;
        //    int iCntr;
        //    TextWriter rLogFile;
        //    if (File.Exists(sFilename) == false)
        //    {
        //        sMsg = "Date; Time";
        //        for (iCntr = 0; iCntr < sHeader.Length; iCntr++)
        //        {
        //            sMsg = sMsg + "; " + sHeader[iCntr];
        //        }
        //        sMsg = sMsg + "; V01";
        //        try
        //        {
        //            rLogFile = new StreamWriter(sFilename, false);
        //            rLogFile.WriteLine(sMsg);
        //            rLogFile.Close();
        //            sErrMsg = "";
        //        }
        //        catch (Exception ex)
        //        {
        //            sErrMsg = "Err: Writing header log file <" + sFilename + ">: " +
        //            ex.Message;
        //        }
        //    }
        //    else
        //    {
        //        sErrMsg = "Err: Header log file <" + sFilename + "> already exists!";
        //    }
        //}
    }
    public class LayerBusiness
    {
        LayerData rLayerData;
        public LayerBusiness(LayerData pld)
        {
            rLayerData = pld;
        }
        public string GetSerialPortData(int iMaxSize)
        {
            return rLayerData.EmptyReadBuffer(iMaxSize, 16, 500);
        }
        public string OpenComPort(string sComPort)
        {
            string sBuf;
            rLayerData.Open(sComPort, out sBuf);
            
        return sBuf;
        }
        public void CloseComPort()
        {
            rLayerData.Close();
        }
        public bool ChkOpenComPort
        {
            get
            {
                return rLayerData.ChkOpen;
            }
        }
    }
    public class LayerUser
    {
        LayerBusiness rLayerBusiness;
        public LayerUser(LayerBusiness plb)
        {
            rLayerBusiness = plb;
        }
        public void MainLoop()
        {
            ConsoleKey cKey = ConsoleKey.S;
            ConsoleKeyInfo cKeyInfo;
            while (cKey != ConsoleKey.Q)
            {
                Console.WriteLine(" R: display of raw COM port data");
                Console.WriteLine(" Q: Quit application");
                cKeyInfo = Console.ReadKey();
                cKey = cKeyInfo.Key;
                cKey = UserSelection(cKey);
            }
            rLayerBusiness.CloseComPort();
        }
        private ConsoleKey UserSelection(ConsoleKey cKey)
        {
            string sBuf;
            int iCnt = 0;
            switch (cKey)
            {
                case ConsoleKey.R:
                    Console.WriteLine(" Display raw data ..");
                    rLayerBusiness.OpenComPort("COM1");
                    while (cKey != ConsoleKey.Q)
                    {
                        sBuf = rLayerBusiness.GetSerialPortData(128);
                        if (sBuf.Length > 0)
                        {
                            Console.WriteLine("Rx[" + iCnt.ToString() + "]=<" + sBuf + "> ");
                            iCnt++;
                        }
                        if (Console.KeyAvailable == true)
                        {
                            cKey = Console.ReadKey().Key;
                        }
                        
                    }
                    rLayerBusiness.CloseComPort();
                    break;
                default:
                    break;
            }
            return cKey;
        }
    }
}