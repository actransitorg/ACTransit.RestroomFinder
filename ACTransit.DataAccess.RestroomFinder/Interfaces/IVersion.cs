using System;

namespace ACTransit.DataAccess.RestroomFinder.Interfaces
{
    public interface IHistoryVersion
    {
        DateTime SysStartTime{ get; set; }

        DateTime SysEndTime { get; set; }
    }
}
