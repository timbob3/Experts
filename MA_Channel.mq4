//+------------------------------------------------------------------+
//|                                                   MA_Channel.mq4 |
//|                                                      Coders Guru |
//|                                            http://www.xpworx.com |
//+------------------------------------------------------------------+
#property copyright "Coders Guru"
#property link      "http://www.xpworx.com"
//"Last Modified: 2010.10.16 20:30";

//---- input parameters
extern         double            Lots                       = 1;
extern         int               TakeProfit                 = 80;
extern         int               StopLoss                   = 80;
extern         int               TrailingStop               = 21;
extern         bool              STP_Broker                 = true;
extern         int               UpperSMA                   = 10;
extern         int               LowerSMA                   = 8;

int      MagicNumber          = 12345;
double   mPoint               = 0.0001;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
{
   MagicNumber = GetMagicNumber(558854);
   
   mPoint = GetPoint();
   
   return(0);
}
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
{
   return(0);
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
   int ticket;
   
   if((OrdersTotal() < 1 || isNewSymbol(MagicNumber))) 
   {
      if( High[1] < iMA(NULL,0,LowerSMA,0,MODE_SMA,PRICE_LOW,1) && High[2] < iMA(NULL,0,LowerSMA,0,MODE_SMA,PRICE_LOW,2))
      {
         ticket = OpenOrder(STP_Broker,Symbol(),OP_BUY,Lots,5,Ask-StopLoss*mPoint,Ask+TakeProfit*mPoint,MagicNumber,WindowExpertName(),5);
         if(ticket>0)
         {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
         }
         else Print("Error opening BUY order : ",GetLastError()); 
      }
      if(Low[1] > iMA(NULL,0,UpperSMA,0,MODE_SMA,PRICE_HIGH,1) && Low[2] > iMA(NULL,0,UpperSMA,0,MODE_SMA,PRICE_HIGH,2) )
      {
         ticket = OpenOrder(STP_Broker,Symbol(),OP_SELL,Lots,5,Bid+StopLoss*mPoint,Bid-TakeProfit*mPoint,MagicNumber,WindowExpertName(),5);
         if(ticket>0)
         {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
         }
         else Print("Error opening SELL order : ",GetLastError()); 
      }
   }
     
   if(TrailingStop>0)TrailOrders(TrailingStop,MagicNumber);
   
   return(0);
}
//+------------------------------------------------------------------+

bool isNewSymbol(int magic)
{
   for(int cnt = 0 ; cnt < OrdersTotal() ; cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber()== magic)
      return (False);
    }
    return (True);
}

int GetMagicNumber(int base)
{
   int Reference = 0;
   string symbol = StringUpperCase(Symbol());
   if (StringFind(symbol,"AUDCAD")>-1) Reference = base + 1001 + Period();
   if (StringFind(symbol,"AUDJPY")>-1) Reference = base + 2002 + Period();
   if (StringFind(symbol,"AUDNZD")>-1) Reference = base + 3003 + Period();
   if (StringFind(symbol,"AUDUSD")>-1) Reference = base + 4004 + Period();
   if (StringFind(symbol,"CHFJPY")>-1) Reference = base + 5005 + Period();
   if (StringFind(symbol,"EURAUD")>-1) Reference = base + 6006 + Period();
   if (StringFind(symbol,"EURCAD")>-1) Reference = base + 7007 + Period();
   if (StringFind(symbol,"EURCHF")>-1) Reference = base + 8008 + Period();
   if (StringFind(symbol,"EURGBP")>-1) Reference = base + 9009 + Period();
   if (StringFind(symbol,"EURJPY")>-1) Reference = base + 1010 + Period();
   if (StringFind(symbol,"EURUSD")>-1) Reference = base + 1111 + Period();
   if (StringFind(symbol,"GBPCHF")>-1) Reference = base + 1212 + Period();
   if (StringFind(symbol,"GBPJPY")>-1) Reference = base + 1313 + Period();
   if (StringFind(symbol,"GBPUSD")>-1) Reference = base + 1414 + Period();
   if (StringFind(symbol,"NZDJPY")>-1) Reference = base + 1515 + Period();
   if (StringFind(symbol,"NZDUSD")>-1) Reference = base + 1616 + Period();
   if (StringFind(symbol,"USDCHF")>-1) Reference = base + 1717 + Period();
   if (StringFind(symbol,"USDJPY")>-1) Reference = base + 1818 + Period();
   if (StringFind(symbol,"USDCAD")>-1) Reference = base + 1919 + Period();
   if (Reference == 0) Reference = base + 2020 + Period();
   return(Reference);
}

string StringUpperCase(string str)
{
   int s = StringLen(str);
   int chr = 0;
   string temp;
   for (int c = 0 ; c < s ; c++)
   {
      chr = StringGetChar(str,c);
      if (chr >= 97 && chr <=122) chr = chr - 32;
      temp = temp + CharToStr(chr);
   }
   return (temp);  
}

double GetPoint(string symbol = "")
{
   if(symbol=="" || symbol == Symbol())
   {
      if(Point==0.00001) return(0.0001);
      else if(Point==0.001) return(0.01);
      else return(Point);
   }
   else
   {
      RefreshRates();
      double tPoint = MarketInfo(symbol,MODE_POINT);
      if(tPoint==0.00001) return(0.0001);
      else if(tPoint==0.001) return(0.01);
      else return(tPoint);
   }
}


int OpenOrder(bool STP, string TradeSymbol, int TradeType, double TradeLot, int TradeSlippage, double TradeStopLoss, 
double TradeTakeProfit, int TradeMagicNumber, string TradeComment = "",int TradeExpiration = 0,int TriesCount = 5, int Pause = 500)
{
   int ticket=0, cnt=0;
   
   if(STP)
   {
      if(TradeType == OP_BUY)
      {
         for(cnt = 0 ; cnt < TriesCount ; cnt++)
         {
            if(TradeStopLoss>0 && TradeTakeProfit>0)
            {
               ticket=OrderSend(TradeSymbol,OP_BUY,TradeLot,Ask,TradeSlippage,0,0,TradeComment,TradeMagicNumber,0,Green);
               if(ticket>-1) 
               {
                  OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
                  OrderModify(ticket,OrderOpenPrice(),TradeStopLoss,TradeTakeProfit,0,Green);
               }
            }
            if(TradeStopLoss==0 && TradeTakeProfit==0)
            {
               ticket=OrderSend(TradeSymbol,OP_BUY,TradeLot,Ask,TradeSlippage,0,0,TradeComment,TradeMagicNumber,0,Green);
            }
            
            if(ticket==-1)
            { 
               Sleep(Pause);
               continue;
            }
            else
            {
               break;
            }
         }   
      }
   
      if(TradeType == OP_SELL)
      {   
         for(cnt = 0 ; cnt < TriesCount ; cnt++)
         {
            if(TradeStopLoss>0 && TradeTakeProfit>0)
            {
               ticket=OrderSend(TradeSymbol,OP_SELL,TradeLot,Bid,TradeSlippage,0,0,TradeComment,TradeMagicNumber,0,Red);
               if(ticket>-1) 
               {
                  OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
                  OrderModify(ticket,OrderOpenPrice(),TradeStopLoss,TradeTakeProfit,0,Red);
               }
            }
            if(TradeStopLoss==0 && TradeTakeProfit==0)
            {
               ticket=OrderSend(TradeSymbol,OP_SELL,TradeLot,Bid,TradeSlippage,0,0,TradeComment,TradeMagicNumber,0,Red);
            }
            
            if(ticket==-1)
            { 
               Sleep(Pause);
               continue;
            }
            else
            {
               break;
            }
         }   
      }
   }
   else
   {
      if(TradeType == OP_BUY)
      {
         for(cnt = 0 ; cnt < TriesCount ; cnt++)
         {
            if(TradeStopLoss>0 && TradeTakeProfit>0)
               ticket=OrderSend(TradeSymbol,OP_BUY,TradeLot,Ask,TradeSlippage,TradeStopLoss,TradeTakeProfit,TradeComment,TradeMagicNumber,0,Green);
            if(TradeStopLoss==0 && TradeTakeProfit==0)
               ticket=OrderSend(TradeSymbol,OP_BUY,TradeLot,Ask,TradeSlippage,0,0,TradeComment,TradeMagicNumber,0,Green);
         
            if(ticket==-1)
            { 
               Sleep(Pause);
               continue;
            }
            else
            {
               break;
            }
         }   
      }
   
      if(TradeType == OP_SELL)
      {   
         for(cnt = 0 ; cnt < TriesCount ; cnt++)
         {
            if(TradeStopLoss>0 && TradeTakeProfit>0)
               ticket=OrderSend(TradeSymbol,OP_SELL,TradeLot,Bid,TradeSlippage,TradeStopLoss,TradeTakeProfit,TradeComment,TradeMagicNumber,0,Red);
            if(TradeStopLoss==0 && TradeTakeProfit==0)
               ticket=OrderSend(TradeSymbol,OP_SELL,TradeLot,Bid,TradeSlippage,0,0,TradeComment,TradeMagicNumber,0,Red);
         
            if(ticket==-1)
            { 
               Sleep(Pause);
               continue;
            }
            else
            {
               break;
            }
         }   
      }
   }  
   return(ticket);
}

int TrailOrders(int ts, int magic)
{
   if(ts<=0) return(0);
 
   int result = -1;
   double point = mPoint;//GetPoint();
 
   for(int cnt=0;cnt<OrdersTotal();cnt++) 
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()==OP_SELL && OrderSymbol()==Symbol()  && OrderMagicNumber()==magic)  
      { 
         if (OrderStopLoss()==0)
         {
            result = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+point*ts,OrderTakeProfit(),0,Red);
         }    
 
         if(OrderOpenPrice()-Ask>point*ts)
         {
            if(OrderStopLoss()>(Ask+point*ts)+point)
            {
               result = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+point*ts,OrderTakeProfit(),0,Red);
            }
         }
      }
        
      if(OrderType()==OP_BUY && OrderSymbol()==Symbol()  && OrderMagicNumber()==magic)  
      { 
         if (OrderStopLoss()==0)
         {
            result = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-point*ts,OrderTakeProfit(),0,Green);
         }
             
         if(Bid-OrderOpenPrice()>point*ts)
         {
            if(OrderStopLoss()<(Bid-point*ts)-point)
            {
               result = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-point*ts,OrderTakeProfit(),0,Green);
            }
         }
      }
   }
   
   return(result);
}





