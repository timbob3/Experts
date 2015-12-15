//+------------------------------------------------------------------+
//|                                          Scaling script v1.2.mq4 |
//|                                        Copyright © 2011, tigpips |
//|                                                tigpips@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, tigpips"
#property link      "tigpips@gmail.com"
#property show_inputs

#include <WinUser32.mqh>

extern double Lots = 0.01;
extern int TakeProfit = 50;
extern int StopLoss = 50;
extern int Slippage = 0;
extern int ScaleByPips = 20;
extern int Number_of_Order_Cycle = 4;
extern string Comment_Message = "TLimS";
extern int Magic = 55555;

double dropped_price;
double OrderTP1, OrderSL1;

double buyordertp[200];
double buyordersl[200];

double sellordertp[200];
double sellordersl[200];
int i,Pos,Error,Total,t,t2;
int ret;
   
int start()
{
   if(Digits == 5 || Digits == 3)
   {
      ScaleByPips = ScaleByPips * 10;
      TakeProfit = TakeProfit * 10;
      StopLoss = StopLoss * 10;
   }
   dropped_price = WindowPriceOnDropped();
   ret=MessageBox("Cursor Price: "+DoubleToStr(dropped_price,Digits)+". To buy, click \"yes\". To sell, click \"No\".", "Question - Buy or Sell?", MB_YESNOCANCEL|MB_ICONQUESTION);
   if(ret==IDCANCEL)
   { 
      return(0);
   }
   //If Buy
   else if(ret==IDYES)
   {
      buy_stop_limit();
   }
   //If Sell
   else if(ret==IDNO)
   {
      sell_stop_limit();
   }           
   return(0);
}
//+------------------------------------------------------------------+

void buy_stop_limit()
{
   int k;
   if(TakeProfit != 0)
   {
      OrderTP1 = dropped_price+(TakeProfit*Point);   
   }
   else
   {
      OrderTP1 = 0;
   }
   
   if(StopLoss != 0)
   {
      OrderSL1 = dropped_price-(StopLoss*Point);
   }
   else
   {
      OrderSL1 = 0;
   }
   //if cursor above current price
   if(dropped_price > Ask)
   {
      for(k = 1; k <= Number_of_Order_Cycle ; k++)
      {
         if(k==1)
         {   
            t=OrderSend(Symbol(),OP_BUYSTOP,Lots,dropped_price,Slippage,OrderSL1,OrderTP1,Comment_Message+" Buy Stop Order : "+k,Magic,0,Blue);
            if(t<=0) Print("Error = ",GetLastError());
            else { Print(k+": BUY STOP ticket = ",t);}
         }        
         else if(k>1)
         {  
            if(TakeProfit != 0)
            {
               buyordertp[k] = (dropped_price+(TakeProfit*Point))+((ScaleByPips*(k-1))*Point);
            }
            else
            {
               buyordertp[k] = 0;
            }
   
            if(StopLoss != 0)
            {
               buyordersl[k] = (dropped_price-(StopLoss*Point))+((ScaleByPips*(k-1))*Point);
            }
            else
            {
               buyordersl[k] = 0;
            }
            t2=OrderSend(Symbol(),OP_BUYSTOP,Lots,dropped_price+(ScaleByPips*Point*(k-1)),Slippage,buyordersl[k],buyordertp[k],Comment_Message+" Buy Stop Order : "+k,Magic,0,Blue);
            if(t2<=0) Print("Error = ",GetLastError());
            else { Print(k+": BUY STOP ticket = ",t2);}  
         }
      }            
   }
   //if cursor below current price
   if(dropped_price < Bid)
   {
      for(k = 1; k <= Number_of_Order_Cycle ; k++)
      {
         if(k==1)
         {   
            t=OrderSend(Symbol(),OP_BUYLIMIT,Lots,dropped_price,Slippage,OrderSL1,OrderTP1,Comment_Message+" Buy Limit Order : "+k,Magic,0,Blue);
            if(t<=0) Print("Error = ",GetLastError());
            else { Print(k+": BUY LIMIT ticket = ",t);}
         }        
         else if(k>1)
         {  
            if(TakeProfit != 0)
            {
               buyordertp[k] = (dropped_price+(TakeProfit*Point))-((ScaleByPips*(k-1))*Point);
            }
            else
            {
               buyordertp[k] = 0;
            }
   
            if(StopLoss != 0)
            {
               buyordersl[k] = (dropped_price-(StopLoss*Point))-((ScaleByPips*(k-1))*Point);
            }
            else
            {
               buyordersl[k] = 0;
            }             
            t2=OrderSend(Symbol(),OP_BUYLIMIT,Lots,dropped_price-(ScaleByPips*Point*(k-1)),Slippage,buyordersl[k],buyordertp[k],Comment_Message+" Buy Limit Order : "+k,Magic,0,Blue);
            if(t2<=0) Print("Error = ",GetLastError());
            else { Print(k+": BUY LIMIT ticket = ",t2);}  
         }
      }
   }
}

void sell_stop_limit()
{
   int k;
      if(TakeProfit != 0)
      {
         OrderTP1 = dropped_price-(TakeProfit*Point);   
      }
      else
      {
         OrderTP1 = 0;
      }
      
      if(StopLoss != 0)
      {
         OrderSL1 = dropped_price+(StopLoss*Point);
      }
      else
      {
         OrderSL1 = 0;
      }
               
      if(dropped_price > Ask)
      {
         for(k = 1; k <= Number_of_Order_Cycle ; k++)
         {
            if(k==1)
            {
               t=OrderSend(Symbol(),OP_SELLLIMIT,Lots,dropped_price,Slippage,OrderSL1,OrderTP1,Comment_Message+" Sell Limit Order : "+k,Magic,0,Red);
               if(t<=0) Print("Error = ",GetLastError());
               else { Print(k+": SELL LIMIT ticket = ",t);}
            }        
            else if(k>1)
            {
               if(TakeProfit != 0)
               {
                  sellordertp[k] = (dropped_price-(TakeProfit*Point))+((ScaleByPips*(k-1))*Point);
               }
               else
               {
                  sellordertp[k] = 0;
               }
   
               if(StopLoss != 0)
               {
                  sellordersl[k] = (dropped_price+(StopLoss*Point))+((ScaleByPips*(k-1))*Point);
               }
               else
               {
                  sellordersl[k] = 0;
               }             
               t2=OrderSend(Symbol(),OP_SELLLIMIT,Lots,dropped_price+(ScaleByPips*Point*(k-1)),Slippage,sellordersl[k],sellordertp[k],Comment_Message+" Sell Limit Order : "+k,Magic,0,Red);
               if(t2<=0) Print("Error = ",GetLastError());
               else { Print(k+": SELL LIMIT ticket = ",t2);}       
            }
         }
      }
      if(dropped_price < Bid)
      {
         for(k = 1; k <= Number_of_Order_Cycle ; k++)
         {
            if(k==1)
            {      
               t=OrderSend(Symbol(),OP_SELLSTOP,Lots,dropped_price,Slippage,OrderSL1,OrderTP1,Comment_Message+" Sell Stop Order : "+k,Magic,0,Red);
               if(t<=0) Print("Error = ",GetLastError());
               else { Print(k+": SELL STOP ticket = ",t);}
         
            }        
            else if(k>1)
            {  
               if(TakeProfit != 0)
               {
                  sellordertp[k] = (dropped_price-(TakeProfit*Point))-((ScaleByPips*(k-1))*Point);
               }
               else
               {
                  sellordertp[k] = 0;
               }
   
               if(StopLoss != 0)
               {
                  sellordersl[k] = (dropped_price+(StopLoss*Point))-((ScaleByPips*(k-1))*Point);
               }
               else
               {
                  sellordersl[k] = 0;
               }                 
               t2=OrderSend(Symbol(),OP_SELLSTOP,Lots,dropped_price-(ScaleByPips*Point*(k-1)),Slippage,sellordersl[k],sellordertp[k],Comment_Message+" Sell Stop Order : "+k,Magic,0,Red);
               if(t2<=0) Print("Error = ",GetLastError());
               else { Print(k+": SELL LTOP ticket = ",t2);}             
            }
         }            
      }   
}

//TLimS