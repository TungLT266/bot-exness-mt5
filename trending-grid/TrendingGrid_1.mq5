#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trending-grid/common/MainFunction.mqh>

// Input
double priceCenterInput = 6704500 * _Point;
double gridAmountInput = 6000 * _Point;
double slGridAmountInput = 10000 * _Point;
int totalGridInput = 4;

double volumeInput = 0.01;
int magic2Input = 1;

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
