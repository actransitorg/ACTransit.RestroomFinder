using System;

namespace ACTransit.Framework.Imaging
{
    public class GpsHelper
    {
        public bool IsNegative { get; set; }
        public float Degrees { get; set; }
        public float Minutes { get; set; }
        public float Seconds { get; set; }
        public float Milliseconds { get; set; }

        public static GpsHelper FromDouble(double angleInDegrees)
        {
            //ensure the value will fall within the primary range [-180.0..+180.0]
            while (angleInDegrees < -180.0)
                angleInDegrees += 360.0;

            while (angleInDegrees > 180.0)
                angleInDegrees -= 360.0;

            var result = new GpsHelper { IsNegative = angleInDegrees < 0 };

            //switch the value to positive
            angleInDegrees = Math.Abs(angleInDegrees);

            //gets the degree
            result.Degrees = (int)Math.Floor(angleInDegrees);
            var delta = angleInDegrees - result.Degrees;

            //gets minutes and seconds
            var seconds = (int)Math.Floor(3600.0 * delta);
            result.Seconds = seconds % 60;
            result.Minutes = (int)Math.Floor(seconds / 60.0);
            delta = delta * 3600.0 - seconds;

            //gets fractions
            result.Milliseconds = (int)(1000.0 * delta);

            return result;
        }
    }
}
