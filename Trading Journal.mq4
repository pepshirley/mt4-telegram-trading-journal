//+------------------------------------------------------------------+
//|                                              Trading Journal.mq4 |
//|                                   Copyright 2021,jarvistrade.io |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021,jarvistrade.io"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs

#define        WIDTH  800     // Image width to call ChartScreenShot() 
#define        HEIGHT 600     // Image height to call ChartScreenShot()

#include <Telegram.mqh>

string        cookie       = NULL,headers;
char          post[];
char          results[];
int           resu;
string        baseurl      = "https://api.telegram.org";

string InpToken  = "";//Bot API Token
string InpChatID = "";//Chat ID

input string InpComment = "";//Comment

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMyBot : public CCustomBot
  {
public:
   void              ProcessMessages(void)
     {

      for(int i=0; i<m_chats.Total(); i++)
        {



         CCustomChat *chat = m_chats.GetNodeAtIndex(i);

         if(!chat.m_new_one.done)
           {

            chat.m_new_one.done = true;

            string text = chat.m_new_one.message_text;




           }
        }

     }

  };

CMyBot bot;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   bot.Token(InpToken);
   bot.GetMe();

   SnapChart(Symbol(),0);

   string photo_id;
   long chat_id = (long)InpChatID;

   int out = bot.SendPhoto(photo_id,chat_id,Symbol()+"_"+(string)Period()+"_update.gif",InpComment);
   //SendMessage(InpComment);

   if(out == 0)
     {
      Print("Photo ID "+photo_id);
      
     }


   else
      Comment("Error: "+GetErrorDescription(out));

  

  }
//+------------------------------------------------------------------+
void SendMessage(string msg)
  {

   int timeout = 2000;

   string url = "https://api.telegram.org/bot"+InpToken+"/sendMessage?chat_id="+InpChatID+"&text="+msg;

   resu = WebRequest("GET",url,cookie,NULL,timeout,post,0,results,headers);

  }
//+------------------------------------------------------------------+
void SnapChart(string symbol, long id)
  {


   int            bars_shift=300;// The number of bars when scrolling the chart using ChartNavigate()
   int pos = 0;
   ChartNavigate(0,CHART_END,pos);

   for(int i=0; i<1; i++)
     {
      string now = TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
      int reptime = StringReplace(now,".","_");
      reptime += StringReplace(now,":","_");
      reptime += StringReplace(now," ","_");
      //--- Prepare a text to show on the chart and a file name
      string name = symbol+"_"+(string)Period()+"_update.gif";

      if(FileIsExist(name))
         FileDelete(name);
      //--- Show the name on the chart as a comment
      // Comment(name);
      //--- Save the chart screenshot in a file in the terminal_directory\MQL4\Files\ 
      if(ChartScreenShot(id,name,WIDTH,HEIGHT,ALIGN_RIGHT))
        {
         Print("We've saved the screenshot ",name);
        }

      //---
      pos+=bars_shift;
      //--- Give the user time to look at the new part of the chart
      // Sleep(3000);
      //--- Scroll the chart from the current position bars_shift bars to the right
      ChartNavigate(id,CHART_CURRENT_POS,-bars_shift);
     }

  }
//+------------------------------------------------------------------+
