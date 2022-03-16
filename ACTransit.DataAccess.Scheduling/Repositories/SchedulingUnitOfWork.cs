using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using ACTransit.Entities.Scheduling;
using ACTransit.Framework.DataAccess;

namespace ACTransit.DataAccess.Scheduling.Repositories
{
    public class SchedulingUnitOfWork : UnitOfWorkBase<SchedulingEntities>
    {
        public SchedulingUnitOfWork() : this(new SchedulingEntities(), null) { }

        public SchedulingUnitOfWork(SchedulingEntities context) : this(context, null) { }

        public SchedulingUnitOfWork(string currentUserName) : this(new SchedulingEntities(), currentUserName) { }

        public SchedulingUnitOfWork(SchedulingEntities context, string currentUserName) : base(context) { CurrentUserName = currentUserName; }

        public int AddBooking(string bookingId, string addUserId)
        {
            return Context.Database.ExecuteSqlCommand("exec HASTUS.AddBooking @NewBookingId, @AddUserId",
                    new SqlParameter("@NewBookingId", bookingId), new SqlParameter("@AddUserId", addUserId));
        }

        public int? CommandTimeout
        {
            get { return Context.Database.CommandTimeout; }
            set
            {
                Context.Database.CommandTimeout=value;
            }
        }
    }

    public class SchedulingReadOnlyUnitOfWork : ReadOnlyUnitOfWorkBase<SchedulingEntities>
    {
        public SchedulingReadOnlyUnitOfWork() : this(new SchedulingEntities()) { }

        public SchedulingReadOnlyUnitOfWork(int commandTimeOutSeconds) : this()
        {
            Context.Database.CommandTimeout = commandTimeOutSeconds;
        }

        public SchedulingReadOnlyUnitOfWork(SchedulingEntities context) : base(context) { }

        public int? CommandTimeout
        {
            get { return Context.Database.CommandTimeout; }
            set
            {
                Context.Database.CommandTimeout = value;
            }
        }

        public IEnumerable<GetDepartures_Result> GetDepartures(DateTime? startTime, string originStopIds, string routes)
        {
            return Context.GetDepartures(startTime, originStopIds, routes);            
        }

        public IEnumerable<GetTripInfo_Result> GetTripInfoByTripNumber(int tripNumber)
        {
            return Context.GetTripInfo(tripNumber);
        }

        public IEnumerable<GetDepartures_Result> GetScheduleDepartures()
        {
            return null; //Context.GetDepartures(startTime, originStopIds, routes);
        }

        public IEnumerable<GetTripStops_Result> GetTripStops(string booking, DateTime? todayDate = null, string routeAlpha = null, string direction = null, string scheduleType = null, string stop511 = null)
        {
            return Context.GetTripStops(booking, todayDate, routeAlpha, direction, scheduleType, stop511);
        }

        public IEnumerable<Waypoints> GetWaypoints(string routes = null)
        {
            Context.Waypoints.AsNoTracking();
            var routeArray = routes?.Split(',');
            return
                (from wp in Context.Waypoints
                where routes == null || routeArray.Contains(wp.RouteAlpha)
                select wp).OrderBy(a => a.RouteAlpha).ThenBy(a => a.RouteVarID).ThenBy(a => a.OrderID).ToList();
        }

        public IEnumerable<GetScheduledTrips_Result> GetScheduledTrips(string booking, int? tripStartOffsetMinutes = null, int? tripEndOffsetMinutes = null)
        {
            return Context.GetScheduledTrips(booking, tripStartOffsetMinutes, tripEndOffsetMinutes);
        }

        public IEnumerable<GetTripScheduleInfo_Result> GetTripsScheduleInfo(string booking, string routeAlphas,string direction,string destination, string scheduleType, bool? hasAllStops, string stop511)
        {
            return Context.GetTripScheduleInfo(booking, routeAlphas, direction, destination,scheduleType, hasAllStops, stop511);
        }

        public IEnumerable<GetStopsWithOrder_Result> GetStopsWithOrder(string booking, string routeAlphas, string direction, string destination, string scheduleType)
        {
            return Context.GetStopsWithOrder(booking, routeAlphas, direction, destination, scheduleType);
        }

        public IEnumerable<GetRouteDateExceptions_Result> GetRouteDateExceptions(string booking, string routeAlphas)
        {
            return Context.GetRouteDateExceptions(booking, routeAlphas);
        }

        public IEnumerable<GetRouteStops_Result> GetRouteStops(string booking, string routeAlphas, string direction, string destination, string scheduleType)
        {
            return Context.GetRouteStops(booking, routeAlphas, direction, destination, scheduleType);
        }

        public IEnumerable<GetVehicleOccupancy_Result> GetVehicleOccupancy(string vehicleIds = null)
        {
            return Context.GetVehicleOccupancy(vehicleIds);
        }
    }
}
