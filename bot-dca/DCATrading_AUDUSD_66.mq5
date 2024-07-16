#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/MainFunction.mqh>

// Input
double slAmountInput = 180 * _Point;
bool isTradeBuyFirstInput = true;

int limitGridInput = 6;
bool isOnlyRunOnceInput = true;
int tpNumberFirstInput = 1;
int tpNumberInput = 2;
double volumeInput = 0.01;
ulong magicNumberInput = 666666;

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
