//+------------------------------------------------------------------+
//|                                                    TimeEntry.mq4 |
//|                      Copyright © 2008, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"



extern double Lots                   = 0.1;
extern int    StopLoss               = 50;
extern int    TakeProfit             = 100;

extern bool   Long_Entry             = true;   // Set to "true" or "false".
extern bool   Short_Entry            = false;  // You can have both Long_Entry & Short Entry set to "true".
extern int    Hour_For_Long_Entry    = 16;     //this is your broker's time as displayed in the MArket Watch window.
extern int    Minute_For_Long_Entry  = 35;
extern int    Hour_For_Short_Entry   = 9;      //this is your broker's time as displayed in the Market Watch window.
extern int    Minute_For_Shor_Entry  = 53;
extern double BuyTrailingStop               = 320;
extern double SellTrailingStop              = 380;  
extern double StepTrailingStop              = 40;  
extern int Slippage =5;


int MagicNumber=0, total, i;
bool Place_Sell=true;
bool Place_Buy=true;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   if (Symbol()=="AUDCADm" || Symbol()=="AUDCAD") {MagicNumber=101;}
   if (Symbol()=="AUDCHFm" || Symbol()=="AUDCHF") {MagicNumber=102;}
   if (Symbol()=="AUDJPYm" || Symbol()=="AUDJPY") {MagicNumber=103;}
   if (Symbol()=="AUDNZDm" || Symbol()=="AUDNZD") {MagicNumber=104;}
   if (Symbol()=="AUDUSDm" || Symbol()=="AUDUSD") {MagicNumber=105;}
   if (Symbol()=="CADCHFm" || Symbol()=="CADCHF") {MagicNumber=106;}
   if (Symbol()=="CADJPYm" || Symbol()=="CADJPY") {MagicNumber=107;}
   if (Symbol()=="CHFJPYm" || Symbol()=="CHFJPY") {MagicNumber=108;}
   if (Symbol()=="EURAUDm" || Symbol()=="EURAUD") {MagicNumber=109;}
   if (Symbol()=="EURCADm" || Symbol()=="EURCAD") {MagicNumber=110;}
   if (Symbol()=="EURCHFm" || Symbol()=="EURCHF") {MagicNumber=111;}
   if (Symbol()=="EURGBPm" || Symbol()=="EURGBP") {MagicNumber=112;}
   if (Symbol()=="EURJPYm" || Symbol()=="EURJPY") {MagicNumber=113;}
   if (Symbol()=="EURUSDm" || Symbol()=="EURUSD") {MagicNumber=114;}
   if (Symbol()=="EURNZdm" || Symbol()=="EURNZD") {MagicNumber=115;}
   if (Symbol()=="GBPAUDm" || Symbol()=="GBPAUD") {MagicNumber=116;} 
   if (Symbol()=="GBPCADm" || Symbol()=="GBPCAD") {MagicNumber=117;} 
   if (Symbol()=="GBPCHFm" || Symbol()=="GBPCHF") {MagicNumber=118;}   
   if (Symbol()=="GBPJPYm" || Symbol()=="GBPJPY") {MagicNumber=119;}
   if (Symbol()=="GBPNZDm" || Symbol()=="GBPNZD") {MagicNumber=120;}
   if (Symbol()=="GBPUSDm" || Symbol()=="GBPUSD") {MagicNumber=121;}
   if (Symbol()=="NZDCADm" || Symbol()=="NZDCAD") {MagicNumber=122;}
   if (Symbol()=="NZDCHFm" || Symbol()=="NZDCHF") {MagicNumber=123;}
   if (Symbol()=="NZDJPYm" || Symbol()=="NZDJPY") {MagicNumber=124;}
   if (Symbol()=="NZDUSDm" || Symbol()=="NZDUSD") {MagicNumber=125;}
   if (Symbol()=="USDCHFm" || Symbol()=="USDCHF") {MagicNumber=126;}
   if (Symbol()=="USDJPYm" || Symbol()=="USDJPY") {MagicNumber=127;}
   if (Symbol()=="USDCADm" || Symbol()=="USDCAD") {MagicNumber=128;}
   if (Symbol()=="USDMXNm" || Symbol()=="USDMXN") {MagicNumber=129;}
   if (MagicNumber==0) {MagicNumber = 199;}    
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   if(Long_Entry==true && Hour()==Hour_For_Long_Entry && Minute()>=Minute_For_Long_Entry && IsTradeAllowed()==true)
   {
      if(Place_Buy == true) 
        {
        OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Ask-StopLoss*Point,Ask+TakeProfit*Point,"WNV Buy",MagicNumber,0,Blue); 
        Place_Buy=false;
             {
             if(IsTradeAllowed()==false) Print("Trade not allowed");
             }
             return(0);
         }
    }     
   
   if(Short_Entry==true && Hour()==Hour_For_Short_Entry && Minute()>=Minute_For_Long_Entry && IsTradeAllowed()==true)
   {
      if(Place_Sell == true)
        {
        OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+StopLoss*Point,Bid-TakeProfit*Point,"WNV Sell",MagicNumber,0,Red);
        Place_Sell=false;    
             {
             if(IsTradeAllowed()==false) Print("Trade not allowed");
             }
             return(0);
         }
   }
   
   //+------------------------------------------------------------------+
//----
     if(BuyTrailingStop > 0)  total = OrdersTotal();
   {
      for(i = 0; i < total; i++)
      {
         OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         
         if(OrderSymbol() != Symbol())  continue;   //
         
         if(OrderType() == OP_BUY)
         {
            if(Bid > (OrderOpenPrice() + Point * BuyTrailingStop))
            {
               if((OrderStopLoss() == 0) || (OrderStopLoss() < (Bid - Point * (BuyTrailingStop + StepTrailingStop))))
               {
                  OrderModify(OrderTicket(), OrderOpenPrice(), Bid - Point * BuyTrailingStop, OrderTakeProfit(), 0);
               }
            }
         }
       }
     }  
  
 if(SellTrailingStop > 0) total = OrdersTotal();
   {
      for(i = 0; i < total; i++)
      {
         OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         
         if(OrderSymbol() != Symbol())  continue;   //
         
         if(OrderType() == OP_SELL)       
         {
            if(Ask < (OrderOpenPrice() - Point * SellTrailingStop))
            {
               if((OrderStopLoss() == 0) || (OrderStopLoss() > (Ask + Point * (SellTrailingStop + StepTrailingStop))))
               {
                  OrderModify(OrderTicket(), OrderOpenPrice(), Ask + Point * SellTrailingStop, OrderTakeProfit(), 0);
               }
            }
         }
      }
   }
   
//----
   return(0);
  }


//+------------------------------------------------------------------+