#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading-dca/common/CommonFunction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading-dca/common/CreateOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading-dca/common/RemoveOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading-dca/common/CreateValueGlobal.mqh>
// #include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading-dca/common/ClosePositionAction.mqh>

// Input
extern double volumeInput;
extern double gridAmountInput;
extern int limitPositionInput;
extern ulong magicNumberInput;

// Global
int gridNoCurrentGlobal = 0;
double volumeBuyTotalGlobal = 0;
double volumeSellTotalGlobal = 0;

// Constants
int DELAY_SECOND_CONSTANT = 10;
string BUY_TYPE_CONSTANT = "BUY";
string SELL_TYPE_CONSTANT = "SELL";

int OnInitFunction()
{
    Print("Start bot");

    MainFunction();

    EventSetTimer(DELAY_SECOND_CONSTANT);

    return (INIT_SUCCEEDED);
}

void MainFunction()
{
    int gridNoCurrentNew = GetGridNoCurrent();
    if (gridNoCurrentNew <= 0)
    {
        return;
    }
    if (gridNoCurrentGlobal != gridNoCurrentNew)
    {
        gridNoCurrentGlobal = gridNoCurrentNew;
        Print("Grid no current: ", gridNoCurrentGlobal);
    }

    RefreshGlobalVariable();
    RemoveOrderAction();
    CreateOrderAction();
    // ClosePositionAction();
}

void RefreshGlobalVariable()
{
    double volumeBuyTotalNew = GetVolumeBuyTotal();
    double volumeSellTotalNew = GetVolumeSellTotal();
    if (volumeBuyTotalGlobal != volumeBuyTotalNew || volumeSellTotalGlobal != volumeSellTotalNew)
    {
        volumeBuyTotalGlobal = volumeBuyTotalNew;
        volumeSellTotalGlobal = volumeSellTotalNew;
        Print("Total volume: Buy: ", volumeBuyTotalGlobal, " - Sell: ", volumeSellTotalGlobal);
    }
}
