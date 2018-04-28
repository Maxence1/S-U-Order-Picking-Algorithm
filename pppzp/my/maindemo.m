orders=createRandOrder(50);
[neworders,totalsavedis,previousTotalDis,afterTotalDis]=orderBatching(orders);
picker = Sjisuanchangdu(neworders(1,1).list);