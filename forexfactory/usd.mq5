#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/forexfactory/common/MainFunction.mqh>

// Input
double volumeInput = 0.03;
ulong deviationInput = 10;
double orderAmountInput = 35 * _Point;
double slAmountInput = 35 * _Point;
double tpAmountInput = 350 * _Point;

int OnInit()
{
   return OnInitFunction();
}

void OnDeinit(const int reason)
{
   Print("EA đã bị gỡ bỏ, lý do: ", reason);
}

void OnTimer()
{
   MainFunction();
}

void OnTick() {}
