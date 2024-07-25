#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/forexfactory/common/ModifyPositionSLAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/forexfactory/common/RemoveOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/forexfactory/common/CreateOrderAction.mqh>

// Input
extern double volumeInput;
extern ulong deviationInput;
extern double orderAmountInput;
extern double slAmountInput;
extern double tpAmountInput;

// Global
ulong magicGlobal = 222;

// Constants
int DELAY_SECOND_CONSTANT = 1;
string BUY_TYPE_CONSTANT = "BUY";
string SELL_TYPE_CONSTANT = "SELL";
string UNKNOWN_CONSTANT = "UNKNOWN";

int OnInitFunction()
{
    Print("Start bot");
    Print("Input: Order amount: ", orderAmountInput, " - SL amount: ", slAmountInput, " - TP amuunt: ", tpAmountInput, " - Volume: ", volumeInput, " - Volume: ", volumeInput, " - Magic:", magicGlobal);

    CreateOrderAction();

    EventSetTimer(DELAY_SECOND_CONSTANT);

    return (INIT_SUCCEEDED);
}

void MainFunction()
{
    RemoveOrderAction();
    ModifyPositionSLAction();
}
