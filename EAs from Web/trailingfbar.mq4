//+------------------------------------------------------------------+
//|                                                 Trailing Bar.mq4 |
//|                                               Copyright 2013, me |
//|                                                                  |
//+------------------------------------------------------------------+

//This EA trails 1 bar /high low and opens two positions. The position size and stoploss should be provided. If the market makes
//a swing that invalidates the chhosen stoploss, it will be adjusted to one pip beyond the extreme of the swing. Also, the user
//may set an expiration period (in bars), after which the EA will do any nothing. The EA should be removed from the chart after
//the trades are opened or the expiration is reached.


#property copyright "me"

#include <customs.mqh>

extern double LotSize;
extern double StopLoss;
extern bool TrailHigh;  //Otherwise low
extern int Slippage = 5;
extern int MagicNumber = 09876;
extern int Expiration=0; //in bars, 0 for no expiration


//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{

	static int	BarCount = 0;
	static int OrdersMade=0;
	static int Ticket=0;

	static datetime CurrentTimeStamp;
	if(CurrentTimeStamp != Time[0]) 
	{
		CurrentTimeStamp = Time[0];
		BarCount++;
	}

	static bool AlertMade = 0;
	if((BarCount>Expiration && Expiration!=0) || OrdersMade > 1 )
	{
		if(!AlertMade){
			Alert("Two positions were opened.");
			AlertMade = 1;
		}
		else return(0);
	}



	int Retries=0;      //for retrying orders later
	int MaxRetries = 5;	
	int ErrCode;
	bool ModSuccess;

	int UseSlippage = GetSlippage(Symbol(),Slippage);

	///////////////////////
	//////buy part ////////
	//////////////////////

	if(TrailHigh && Close[0]>High[1]){	

		for( ; OrdersMade<2; OrdersMade++){		//Open 2 units

			for(;;){		//retry a few times if need be

				Ticket = OpenBuyOrder(Symbol(),LotSize,UseSlippage,MagicNumber);

				if(Ticket == -1) ErrCode = GetLastError();
				if(Retries <= MaxRetries && ErrorCheck(ErrCode) == true) Retries++;  //checks if it might be useful to retry
				else break;
			}
			Retries = 0;  //reset


			//Adjusting stop if order is made.			//Doing this seperately to accomodate ECN brokers -- I read they don't allow                                            
			if(Ticket > 0 && StopLoss > 0)				//setting sl/tp with the orders
			{
				double NewLow = FindSwingLow(BarCount);   //If there is a swing low since init(),adjust stop to that
				if(StopLoss > NewLow) StopLoss = NewLow - PipPoint(Symbol()); //one pip below swing low

				for(;;){
					ModSuccess = AddStopProfit(Ticket,StopLoss,0); 

					if(!ModSuccess) ErrCode = GetLastError();
					if(Retries <= MaxRetries && ErrorCheck(ErrCode) == true) Retries++;
					else break;
				}
			}
			Retries = 0;  //reset
		}
	}

	///////////////////////
	//////sell part ///////
	///////////////////////

	else if(!TrailHigh && Close[0]<Low[1]){	

		for( ; OrdersMade<2; OrdersMade++){		//Open 2 units

			for(;;){		//retry a few times if need be

				Ticket = OpenSellOrder(Symbol(),LotSize,UseSlippage,MagicNumber);

				if(Ticket == -1) ErrCode = GetLastError();
				if(Retries <= MaxRetries && ErrorCheck(ErrCode) == true) Retries++;  //checks if it might be useful to retry
				else break;
			}
			Retries = 0;  //reset


			//Adjusting stop if order is made.			//Doing this seperately to accomodate ECN brokers -- I read they don't allow                                            
			if(Ticket > 0 && StopLoss > 0)				//setting sl/tp with the orders
			{
				double NewHigh = FindSwingHigh(BarCount);   //If there is a swing low since init(),adjust stop to that
				if(StopLoss <NewHigh) StopLoss = NewHigh + PipPoint(Symbol()); //one pip abovethe swing high

				for(;;){
					ModSuccess = AddStopProfit(Ticket,StopLoss,0); 

					if(!ModSuccess) ErrCode = GetLastError();
					if(Retries <= MaxRetries && ErrorCheck(ErrCode) == true) Retries++;
					else break;
				}
			}
			Retries = 0;  //reset
		}
	}
}
//+------------------------------------------------------------------+


