//+------------------------------------------------------------------+
//|                                                       105-v4.mq4 |
//|                               Copyright 2015, tj.weston@live.com |
//|                                                      https://www |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, tj.weston@live.com"
#property link      "https://www"
#property version   "1.00"
#property strict


extern int MagicN = 0000;
extern int TakeProfit = 100;
extern int StopLoss   = 200;
extern double TrailingStop = 10;

extern double lot1   =  0.01;
extern double lot2   =  0.03;

extern double lot3   =  0.09;
extern double lot4   =  0.27;
extern double lot5   =  0.81;
extern double lot6   =  1.62;
extern double lot7   =  3.24;

extern double lot8   =  6.48;
extern double lot9   =  12.96;
extern double lot10  =  15.36;
extern double lot11  =  30.72;
//extern int opentime = 4 ;
//extern int closetime = 13;

 
extern int opentime = 16;
extern bool canTrade = true;
int Slippage = 50;
 
//--- global variable

//double MasterUpperLevel =0;
//double MasterLowerLevel =0;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
  
  //int j=0;
  // int hourtime= TimeHour(Time[j]);
 //Comment("TimeHour() = ",hourtime);
//---
int total = OrdersTotal();


int i;
double OpenLongOrders = 0, OpenShortOrders = 0, PendLongs =0, PendShorts =0;


//
if(canTrade == true )//hourtime==opentime )
{

if(total == 0 && OpenLongOrders == 0 && OpenShortOrders == 0 && PendLongs == 0 && PendShorts == 0)
      {
             openbuy();
             sellstop();
      }
}






//
 for( i=total-1;i>=0;i--)       
   {
     OrderSelect(i, SELECT_BY_POS );
    if ( OrderSymbol() == Symbol() && OrderMagicNumber() == MagicN)
         {
           int type = OrderType();

if (type == OP_BUY )       {OpenLongOrders=OpenLongOrders+1;}
if (type == OP_SELL )      {OpenShortOrders=OpenShortOrders+1;}
if (type == OP_BUYSTOP )   {PendLongs=PendLongs+1;}
if (type == OP_SELLSTOP )  {PendShorts=PendShorts+1;}
  
double myAccount = AccountBalance();  
  
Comment("Open Orders = ",total,"\nopenlongOrders = ",OpenLongOrders," \nopenShortOrders = ",
OpenShortOrders,"\nPendLongs = ",PendLongs,
"\nPendShorts = ",PendShorts,
"\nProfit = ", getProfit(),
"\nAccount Balance = ",myAccount);  
  
  
  if(total == 2 && OpenLongOrders == 1 && OpenShortOrders == 1 && PendLongs == 0 && PendShorts == 0)
      {
             buystop();
      }
    if(total == 3 && OpenLongOrders == 2 && OpenShortOrders == 1 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop1();
      }  
      if(total == 4 && OpenLongOrders == 2 && OpenShortOrders == 2 && PendLongs == 0 && PendShorts == 0)
      {
             buystop1();
      }    
      
      if(total == 5 && OpenLongOrders == 3 && OpenShortOrders == 2 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop2();
      }
      if(total == 6 && OpenLongOrders == 3 && OpenShortOrders == 3 && PendLongs == 0 && PendShorts == 0)
      {
             buystop2();
      }
      if(total == 7 && OpenLongOrders == 4 && OpenShortOrders == 3 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop3();
      }
      if(total == 8 && OpenLongOrders == 4 && OpenShortOrders == 4 && PendLongs == 0 && PendShorts == 0)
      {
             buystop3();
      }
      if(total == 9 && OpenLongOrders == 5 && OpenShortOrders == 4 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop4();
      }
      if(total == 10 && OpenLongOrders == 5 && OpenShortOrders == 5 && PendLongs == 0 && PendShorts == 0)
      {
             buystop4();
      }
      if(total == 1 && OpenLongOrders == 0 && OpenShortOrders == 0 && (PendLongs == 1 || PendShorts == 1))
      {
             deleteallpendingorders();
      }
       
      Sleep(2000);
      }
   } 
  }
  
  
  
  
//+------------------------------------------------------------------+
void openbuy()
{
 OrderSend(Symbol(),OP_BUY,lot1,Ask,3,Ask-StopLoss*Point,Ask+TakeProfit*Point,NULL,MagicN,0,clrBlue);
}

void sellstop()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot2,Ask-TakeProfit*Point,3,
 (Ask-TakeProfit*Point)+StopLoss*Point,(Ask-TakeProfit*Point)-TakeProfit*Point,NULL,MagicN,0,clrBlue);
}

void buystop()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot3,Ask+TakeProfit*Point,3,
 (Ask+TakeProfit*Point)-StopLoss*Point,(Ask+TakeProfit*Point)+TakeProfit*Point,NULL,MagicN,0,clrBlue);
}
void sellstop1()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot4,Ask-TakeProfit*Point,3,
 (Ask-TakeProfit*Point)+StopLoss*Point,(Ask-TakeProfit*Point)-TakeProfit*Point,NULL,MagicN,0,clrBlue);
}

void buystop1()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot5,Ask+TakeProfit*Point,3,
 (Ask+TakeProfit*Point)-StopLoss*Point,(Ask+TakeProfit*Point)+TakeProfit*Point,NULL,MagicN,0,clrBlue);
}
void sellstop2()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot6,Ask-TakeProfit*Point,3,
 (Ask-TakeProfit*Point)+StopLoss*Point,(Ask-TakeProfit*Point)-TakeProfit*Point,NULL,MagicN,0,clrBlue);
}

void buystop2()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot7,Ask+TakeProfit*Point,3,
 (Ask+TakeProfit*Point)-StopLoss*Point,(Ask+TakeProfit*Point)+TakeProfit*Point,NULL,MagicN,0,clrBlue);
}

void sellstop3()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot8,Ask-TakeProfit*Point,3,
 (Ask-TakeProfit*Point)+StopLoss*Point,(Ask-TakeProfit*Point)-TakeProfit*Point,NULL,MagicN,0,clrBlue);
}

void buystop3()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot9,Ask+TakeProfit*Point,3,
 (Ask+TakeProfit*Point)-StopLoss*Point,(Ask+TakeProfit*Point)+TakeProfit*Point,NULL,MagicN,0,clrBlue);
}

void sellstop4()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot10,Ask-TakeProfit*Point,3,
 (Ask-TakeProfit*Point)+StopLoss*Point,(Ask-TakeProfit*Point)-TakeProfit*Point,NULL,MagicN,0,clrBlue);
}

void buystop4()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot11,Ask+TakeProfit*Point,3,
 (Ask+TakeProfit*Point)-StopLoss*Point,(Ask+TakeProfit*Point)+TakeProfit*Point,NULL,MagicN,0,clrBlue);
}



//=========================================================
//
//=========================================================

void deleteallpendingorders()
{
   for(int i=0;i<OrdersTotal();i++)
   {
     OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
     if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicN && ((OrderType()==OP_BUY) || (OrderType()==OP_SELL) ||(OrderType()==OP_BUYSTOP) || (OrderType()==OP_SELLSTOP) || (OrderType()==OP_BUYLIMIT) || (OrderType()==OP_SELLLIMIT)))
     {
       OrderDelete(OrderTicket());
     }   
   }
}

void CloseAll()
{
   bool   Result;
   int    i,Pos,Error;
   int    Total=OrdersTotal();
   
   if(Total>0)
   {
     for(i=Total-1; i>=0; i--) 
     {
       if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
       {
         Pos=OrderType();
         if(Pos==OP_BUY)
         {Result=OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, clrBlue);}
         if(Pos==OP_SELL)
         {Result=OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, clrBlue);}
         if((Pos==OP_BUYSTOP)||(Pos==OP_SELLSTOP)||(Pos==OP_BUYLIMIT)||(Pos==OP_SELLLIMIT))
         {Result=OrderDelete(OrderTicket(), clrRed);}
//-----------------------
         if(Result!=true) 
          { 
             Error=GetLastError(); 
             Print("LastError = ",Error); 
          }
         else Error=0;
//-----------------------
       }   
     }
   }
   //return(0); 
}


double getProfit()
{
   double Profit = 0;
   for (int TradeNumber = OrdersTotal(); TradeNumber >= 0; TradeNumber--)
   {
     if (OrderSelect(TradeNumber, SELECT_BY_POS, MODE_TRADES))
     Profit = Profit + OrderProfit() + OrderSwap();
   }
   return (Profit);
}
//
//int CheckForClose()
//{
//
//   //for(int iPos = OrdersTotal()-1; iPos >= 0; iPos--)
//   //{
//   //   if(OrderSelect(iPos,SELECT_BY_POS,MODE_TRADES) &&
//   //   OrderSymbol()==Symbol() &&
//   //   OrderMagicNumber()==MAGICMA)
//   //   {
//   //   int Duration = TimeCurrent() - OrderOpenTime();
//   //   if(Duration < 1*24*3600) continue;
//   //   CloseAll();
//   //   }
//   //}
//   
//
//
//
////  if(Amount>0 && getProfit()>=Amount)
////   {
////   CloseAll();
////   }
////   
////   if(getProfit()<=-120)
////      {
////      CloseAll();
////      }
//    
//
//for(int cnt=0;cnt<OrdersTotal();cnt++)
//     {
//      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
//      if( OrderSymbol()==Symbol() && OrderMagicNumber()==MagicN)
//        
//        {
//         if(OrderType()==OP_BUY)
//           {
//            if(OrderOpenPrice()-Ask>StopLoss*Point)
//              {
//               OrderClose(OrderTicket(),OrderLots(),Bid,0,Violet); return(0);
//              }
//            if(TrailingStop>0)
//              {
//               if(Bid-OrderOpenPrice()>Point*TrailingStop)
//                 {
//                  if(OrderStopLoss()<Bid-Point*TrailingStop)  // the bit that stops modifying once the price slips back..
//                    {
//                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,Green); return(0);
//                    }
//                 }
//              }
//           }
//         if(OrderType()==OP_SELL)
//           {
//            if(Bid-OrderOpenPrice()>StopLoss*Point)
//              {
//               OrderClose(OrderTicket(),OrderLots(),Ask,0,Violet); return(0);
//              }
//            if(TrailingStop>0)
//              {
//               if((OrderOpenPrice()-Ask)>(Point*TrailingStop))
//                 {
//                  if((OrderStopLoss()>(Ask+Point*TrailingStop)) || (OrderStopLoss()==0))
//                    {
//                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,Red); return(0);
//                    }
//                 }
//              }
//           }
//         }
//       }
//       }
//       
//       
  
