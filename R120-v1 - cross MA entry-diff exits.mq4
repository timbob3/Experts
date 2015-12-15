//+------------------------------------------------------------------+
//|                          R120-v1 - cross MA entry-diff exits.mq4 |
//|                               Copyright 2015, tj.weston@live.com |
//|                                                             none |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, tj.weston@live.com"
#property link      "none"
#property version   "1.00"
#property strict


//+------------------------------------------------------------------+
//|   Based on built in Moving Average example                       |
//+------------------------------------------------------------------+




#define MAGICMA  1201
//--- Inputs
input double Lots          =0.1;
input double MaximumRisk   =0.02;
input double DecreaseFactor=3;
input int    MovingPeriod  =180;
input int    MovingShift   =0;
input int    PeriodMA1     =10;
input int    PeriodMA2     =80;

input int    Stoploss      = 300;






//+------------------------------------------------------------------+
//| Calculate open positions                                         |
//+------------------------------------------------------------------+
int CalculateCurrentOrders(string symbol)
  {
   int buys=0,sells=0;
//---
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
//--- return orders volume
   if(buys>0) return(buys);
   else       return(-sells);
  }
//+------------------------------------------------------------------+
//| Calculate optimal lot size                                       |
//+------------------------------------------------------------------+
double LotsOptimized()
  {
   double lot=Lots;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//--- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,1);
//--- calcuulate number of losses orders without a break
   if(DecreaseFactor>0)
     {
      for(int i=orders-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
           {
            Print("Error in history!");
            break;
           }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL)
            continue;
         //---
         if(OrderProfit()>0) break;
         if(OrderProfit()<0) losses++;
        }
      if(losses>1)
         lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
     }
//--- return lot size
   if(lot<0.1) lot=0.1;
   return(lot);
  }
//+------------------------------------------------------------------+
//|                     ENTRY *****                                  |
//+------------------------------------------------------------------+
void CheckForOpen()
  {
   //double ma;
   int    res;
//--- go trading only for first tiks of new bar
   //if(Volume[0]>1) return;
//--- get Moving Average 
 //  ma=iMA(NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,0);
 

   if(Crossed()==1)   //-----BUY conditions
     {
      res=OrderSend(Symbol(),OP_BUY,LotsOptimized(),Ask,3,0,0,"",MAGICMA,0,Blue);
      return;
     } 
 

   if(Crossed()==2)   //---- SELL conditions
     {
      res=OrderSend(Symbol(),OP_SELL,LotsOptimized(),Bid,3,0,0,"",MAGICMA,0,Red);
      return;
     }    
  }
  
  
  
//+------------------------------------------------------------------+
//|    ******           CLOSE   *******                              |
//+------------------------------------------------------------------+

void CheckForClose()
  {
   //double ma;
//--- go trading only for first tiks of new bar
   //if(Volume[0]>1) return;
//--- get Moving Average 
  // ma=iMA(NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,0);
//---
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      //--- check order type 
      if(OrderType()==OP_BUY)
        {
         if(Crossed()==2)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,White))
               Print("OrderClose error ",GetLastError());
           }
         break;
        }
      if(OrderType()==OP_SELL)
        {
         if(Crossed()==1)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,White))
               Print("OrderClose error ",GetLastError());
           }
         break;
        }
     }
//---
  }
  
  int Crossed()
   {
   
   double Ma1 = iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_CLOSE,0);
   double Ma2 = iMA(NULL,0,PeriodMA2,0,MODE_SMA,PRICE_CLOSE,0);
   
    int Last_Direction;
    int Current_Direction;
   
   if (Ma1>Ma2) Current_Direction = 1; // up
   if (Ma1<Ma2) Current_Direction = 2; // down
   
   if (Current_Direction != Last_Direction) // direction has changed
      {
      Last_Direction = Current_Direction;
      return (Last_Direction);
      }
   else
      {
      return (0);
      }
   }
  

  
  
  
//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false)
      return;
//--- calculate open orders by current symbol
   if(CalculateCurrentOrders(Symbol())==0) CheckForOpen();
   else                                    CheckForClose();
//---

Comment("Crossed= ",Crossed()); 
  }
//+------------------------------------------------------------------+