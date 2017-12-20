//+------------------------------------------------------------------+
//|                                              EnvelopeScalper.mq4 |
//|                                                    Anirudh Sodhi |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Anirudh Sodhi"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern double TakeProfit = 10;
extern double StopLoss = 10;
input double Lots = 0.10;
input int Slippage = 0;
input int MA_Period = 200;
input int MA_Method = 0;
input int MA_Applied_Price = 0;
input double Deviation = 0.25;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if (Digits == 3 || Digits == 5) {
      TakeProfit *= 10;
      StopLoss *= 10;
   }
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
//---
   static int crossUpperUp = 0;
   static int crossLowerDown = 0;
   if (newBar()) {
      double upperMA = iEnvelopes(Symbol(), 0, MA_Period, MA_Method, 0, MA_Applied_Price, Deviation, 1, 1);
      double lowerMA = iEnvelopes(Symbol(), 0, MA_Period, MA_Method, 0, MA_Applied_Price, Deviation, 2, 1);
      if (Close[1] > upperMA && crossUpperUp == 0) crossUpperUp = 1;
      else if (Close[1] < lowerMA && crossLowerDown == 0) crossLowerDown = 1;
      else if (Close[1] < upperMA && crossUpperUp == 1) {
         OrderSend(Symbol(), OP_SELL, Lots, Bid, Slippage, Bid + StopLoss * Point, Bid - TakeProfit * Point);
         crossUpperUp = 0;
      }
      else if (Close[1] > lowerMA && crossLowerDown == 1) {
         OrderSend(Symbol(), OP_BUY, Lots, Ask, Slippage, Ask - StopLoss * Point, Ask + TakeProfit * Point);
         crossLowerDown = 0;
      }
   }
  }
//+------------------------------------------------------------------+

bool newBar()
{
   static datetime lastbar;
   datetime curbar = Time[0];
   if(lastbar != curbar)
   {
      lastbar = curbar;
      return true;
   }
   else
   {
      return false;
   }
}