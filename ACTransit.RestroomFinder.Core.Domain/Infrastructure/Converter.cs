using NetTopologySuite;
using DB = ACTransit.DataAccess.RestroomFinder.Core.Entities;
using Restroom = ACTransit.RestroomFinder.Core.Domain.RestroomFinder.Models.Restroom;

namespace ACTransit.RestroomFinder.Core.Domain.Infrastructure
{
    public static class Converter
    {
        public static Restroom ToModel(DB.Restroom obj)
        {
            var geometryFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);
            return new Restroom
            {
                //ACTRoute = obj.ACTRoute,
                Address = obj.Address,
                City = obj.City,
                Country = obj.Country,
                DrinkingWater = obj.DrinkingWater,
                Geo = geometryFactory.CreatePoint(obj.Geo.Coordinate),
                LatDec = obj.LatDec,
                LongDec = obj.LongDec,
                Note = obj.Note,
                Hours = obj.Hours,
                RestroomName = obj.RestroomName,
                RestroomId = obj.RestroomId,
                RestroomType = obj.RestroomType,
                State = obj.State,
                Zip = obj.Zip
            };
        }

    }
}
