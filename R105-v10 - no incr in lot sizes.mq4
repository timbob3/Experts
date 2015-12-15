//+------------------------------------------------------------------+
//|                                   R105-v8 - add stoch filter.mq4 |
//|                               Copyright 2015, tj.weston@live.com |
//|                                                             none |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, tj.weston@live.com"
#property link      "none"
#property version   "1.00"
#property strict



extern int MagicN = 0000;
extern int TakeProfit = 150 ;
extern int StopLoss   = 200 ;
extern int Amount     = 50;


extern double lot1   =  0.2    ;
extern double lot2   =  0.4    ;
extern double lot3   =  0.4    ;
extern double lot4   =  0.4    ;
extern double lot5   =  0.4   ;
extern double lot6   =  0.4    ;
extern double lot7   =  0.4    ;
extern double lot8   =  0.4   ;
extern double lot9   =  0.4   ;
extern double lot10  =  0.4  ;
extern double lot11  =  0.4  ;
extern double lot12   = 0.4   ;
extern double lot13  =  0.4  ;
extern double lot14  =  0.4  ;
extern double lot15  =  0.4  ;
extern double lot16   = 0.4   ;
extern double lot17  =  0.4  ;
extern double lot18  =  0.2 ;
//extern int opentime = 4 ;
//extern int closetime = 13;

 
extern int opentime = 16;
extern bool canTrade = true;
int Slippage = 0;
 





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
  int j=0;
   int hourtime= TimeHour(Time[j]);
 
//---
int total = OrdersTotal();
int i;
double OpenLongOrders = 0, OpenShortOrders = 0, PendLongs =0, PendShorts =0;
//
if(canTrade == true )//if(hourtime==opentime )
{

if(total == 0 && OpenLongOrders == 0 && OpenShortOrders == 0 && PendLongs == 0 && PendShorts == 0)
      {
             openbuy();
              sellstop();
      }}

//
 for( i=0;i<total;i++)       
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
      if(total == 11 && OpenLongOrders == 6 && OpenShortOrders == 5 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop5();
      }
      if(total == 12 && OpenLongOrders == 6 && OpenShortOrders == 6 && PendLongs == 0 && PendShorts == 0)
      {
             buystop5();
      }
      if(total == 13 && OpenLongOrders == 7 && OpenShortOrders == 6 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop6();
      } 
      if(total == 14 && OpenLongOrders == 5 && OpenShortOrders == 5 && PendLongs == 0 && PendShorts == 0)
      {
             buystop6();
      }
      if(total == 15 && OpenLongOrders == 6 && OpenShortOrders == 5 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop7();
      }
      if(total == 16 && OpenLongOrders == 6 && OpenShortOrders == 6 && PendLongs == 0 && PendShorts == 0)
      {
             buystop7();
      }
      if(total == 17 && OpenLongOrders == 7 && OpenShortOrders == 6 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop8();
      }
      
      
      
      
      
      if(total == 1 && OpenLongOrders == 0 && OpenShortOrders == 0 && (PendLongs == 1 || PendShorts == 1))
      {
             deleteallpendingorders();
      }
       
      CheckForClose();
       
      Sleep(2000);
  }
  
     
      
      
  
  }
     
      
  
  }
  
//+------------------------------------------------------------------+
void openbuy()
{
 OrderSend(Symbol(),OP_BUY,lot1,Ask,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot2,Ask-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot3,Ask+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}
void sellstop1()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot4,Ask-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop1()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot5,Ask+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}
void sellstop2()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot6,Ask-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop2()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot7,Ask+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop3()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot8,Ask-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop3()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot9,Ask+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop4()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot10,Ask-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop4()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot11,Ask+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop5()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot12,Ask-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop5()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot13,Ask+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop6()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot14,Ask-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}
void buystop6()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot15,Ask+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop7()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot16,Ask-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop7()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot17,Ask+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop8()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot18,Ask-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
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

//============================================
//////////////////////////////////////////////
//============================================
/*bool checktime()
{
  int i=0;
  int hourtime=TimeHour(Time[i]);
  if (hourtime==opentime){return(true);}
  else if (hourtime==closetime){return(false);}
  else
  return (EMPTY_VALUE);

}*/


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


int CheckForClose()
{
  if(Amount>0 && getProfit()>=Amount)
   {
   CloseAll();
   }
   
   //if(getProfit()<=-120)
   //   {
   //   CloseAll();
   //   }
   return(0);
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

