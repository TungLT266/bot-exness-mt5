#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/MainFunction.mqh>

// Input
double slAmountInput = 6000 * _Point;
bool isTradeBuyFirstInput = true;
int totalMagicInput = 1;

int limitGridInput = 6;
bool isOnlyRunOnceInput = false;
int tpNumberFirstInput = 1;
int tpNumberInput = 2;
double volumeInput = 0.01;
int magic2Input = 99;
string symbolInput = _Symbol;

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
