#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

extern string UNKNOWN_CONSTANT;

struct MagicDetailObject
{
    int magic3;
    double slAmount;
    double priceStart;
    string takeProfitCurrent;
    string takeProfitStart;
    int totalPosition;
};

MagicDetailObject GetDefaultMagicDetailObject()
{
    MagicDetailObject result;
    result.magic3 = 0;
    result.slAmount = 0;
    result.priceStart = 0;
    result.takeProfitCurrent = UNKNOWN_CONSTANT;
    result.takeProfitStart = UNKNOWN_CONSTANT;
    result.totalPosition = 0;
    return result;
}

void CopyArrMagicDetail(MagicDetailObject &source[], MagicDetailObject &taget[])
{
    int size = ArraySize(source);
    ArrayResize(taget, size);
    for (int i = 0; i < size; i++)
    {
        taget[i] = source[i];
    }
}

bool IsEqualArrMagicDetail(MagicDetailObject &arr1[], MagicDetailObject &arr2[])
{
    int size1 = ArraySize(arr1);
    int size2 = ArraySize(arr2);
    if (size1 != size2)
    {
        return false;
    }

    for (int i = 0; i < size1; i++)
    {
        MagicDetailObject value1 = arr1[i];
        MagicDetailObject value2 = arr2[i];

        if (value1.magic3 != value2.magic3)
        {
            return false;
        }
        if (value1.slAmount != value2.slAmount)
        {
            return false;
        }
        if (value1.priceStart != value2.priceStart)
        {
            return false;
        }
        if (value1.takeProfitCurrent != value2.takeProfitCurrent)
        {
            return false;
        }
        if (value1.takeProfitStart != value2.takeProfitStart)
        {
            return false;
        }
        if (value1.totalPosition != value2.totalPosition)
        {
            return false;
        }
    }
    return true;
}

bool IsExitsMagicDetailByMagic3(MagicDetailObject &arr[], int magic3)
{
    for (int i = 0; i < ArraySize(arr); i++)
    {
        MagicDetailObject magicDetail = arr[i];
        if (magicDetail.magic3 == magic3)
        {
            return true;
        }
    }
    return false;
}

int AddArrValueMagicDetail(MagicDetailObject &arr[], MagicDetailObject &value)
{
    int ordinal = ArraySize(arr);
    ArrayResize(arr, ordinal + 1);
    arr[ordinal] = value;
    return ordinal + 1;
}

MagicDetailObject GetMagicDetailByMagic3(MagicDetailObject &arr[], int magic3)
{
    for (int i = 0; i < ArraySize(arr); i++)
    {
        MagicDetailObject magicDetail = arr[i];
        if (magicDetail.magic3 == magic3)
        {
            return magicDetail;
        }
    }
    return GetDefaultMagicDetailObject();
}
