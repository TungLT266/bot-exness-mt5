#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/CommonFunction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/CreateOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/RemoveOrderAction.mqh>

// Input
extern int gridTotalInput;
extern double volumeInput;
extern double gridAmountInput;
extern int limitPositionInput;
extern ulong magicNumberInput;

// Global
double numberStartGridGlobal = 0;
double priceStartGridGlobal = 0;
int differenceBuyAndSellGlobal = 0; // Nếu value > 0 => Buy > Sell

// Constants
int DELAY_SECOND_CONSTANT = 10;
string BUY_TYPE_CONSTANT = "BUY";
string SELL_TYPE_CONSTANT = "SELL";

int OnInitFunction()
{
    // RemoveOrderAll();

    if (gridTotalInput % 2 != 0)
    {
        Print("Grid total invalid.");
        ExpertRemove();
        return (INIT_SUCCEEDED);
    }

    Print("Start bot");

    MainFunction();

    EventSetTimer(DELAY_SECOND_CONSTANT);

    return (INIT_SUCCEEDED);
}

void MainFunction()
{
    double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double startByBid = GetNumberStartGrid(bidPrice);
    double startByAsk = GetNumberStartGrid(askPrice);
    if (startByBid != startByAsk)
    {
        return;
    }

    numberStartGridGlobal = startByBid;
    priceStartGridGlobal = numberStartGridGlobal * gridAmountInput;

    int totalPosition = PositionsTotal();
    if (totalPosition > 0)
    {
        int totalPositionBuy = GetTotalPositionBuy();
        int totalPositionSell = GetTotalPositionSell();

        int differenceBuyAndSellNew = totalPositionBuy - totalPositionSell;
        if (differenceBuyAndSellNew != differenceBuyAndSellGlobal)
        {
            differenceBuyAndSellGlobal = differenceBuyAndSellNew;
            Print("Total lệnh: ", totalPosition, " - Lệnh Buy: ", totalPositionBuy, " - Lệnh Sell: ", totalPositionSell);
        }
    }

    RemoveOrderAction();
    CreateOrderAction();
}
