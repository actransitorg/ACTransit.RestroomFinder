using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Text.RegularExpressions;
using ACTransit.Framework.FileManagement;

namespace ACTransit.Framework.Extensions
{
    public static class StringExtensions
    {
        /// <summary>
        /// Convert a string to a double
        /// </summary>
        /// <returns>A double value, or null when it cannot be converted.</returns>
        public static double? ToDouble( this string str )
        {
            double doubleValue;

            return double.TryParse( str, out doubleValue )
                ? (double?)doubleValue
                : null;
        }

        /// <summary>
        /// Convert a string to an integer
        /// </summary>
        /// <returns>An integer value, or null when cannot be converted.</returns>
        public static int? ToInt( this string str )
        {
            int intValue;

            return int.TryParse( str, out intValue )
                ? (int?)intValue
                : null;
        }

        /// <summary>
        /// Convert a string to a decimal
        /// </summary>
        /// <returns>A decimal value, or null when cannot be converted.</returns>
        public static decimal? ToDecimal( this string str )
        {
            decimal decimalValue;

            return decimal.TryParse( str, out decimalValue )
                ? (decimal?)decimalValue
                : null;
        }

        /// <summary>
        /// Convert a string to a long
        /// </summary>
        /// <returns>A long value, or null when cannot be converted.</returns>
        public static long? ToLong( this string str )
        {
            long longValue;

            return long.TryParse( str, out longValue )
                ? (long?)longValue
                : null;
        }

        /// <summary>
        /// Convert a string to a datetime
        /// </summary>
        /// <returns>A datetime value, or null when cannot be converted.</returns>
        public static DateTime? ToDateTime( this string str )
        {
            DateTime dateValue;

            return DateTime.TryParse( str, out dateValue )
                ? (DateTime?)dateValue
                : null;
        }

        /// <summary>
        /// Convert a string to a bool
        /// </summary>
        /// <returns>A bool value, or null when cannot be converted.</returns>
        public static bool? ToBool( this string str )
        {
            bool boolValue;

            return bool.TryParse( str, out boolValue )
                ? (bool?)boolValue
                : null;
        }

        /// <summary>
        /// Convert a string to an object of any type. 
        /// </summary>
        /// <returns>Casted value, or the default value for requested type when cast fails</returns>
        public static T Cast<T>( this string str )
        {
            try
            {
                return (T)Convert.ChangeType( str, typeof( T ) );
            }
            catch( Exception )
            {
                return default( T );
            }
        }

        /// <summary>
        /// Return a list of values converted to type T
        /// </summary>
        /// <returns>an IEnumerable of type T</returns>
        public static IEnumerable<T> ToEnumerable<T>( this string str, string seperator = "," )
        {
            return str.Split( new[] { seperator }, StringSplitOptions.RemoveEmptyEntries ).OfType<T>();
        }

        /// <summary>
        /// Tries to convert a string into a Dictionaty
        /// </summary>
        /// <typeparam name="TKey">Key data type</typeparam>
        /// <typeparam name="TValue">Value data type</typeparam>
        /// <returns>Returnes a Dictionary of the desired type.</returns>
        public static IDictionary<TKey, TValue> ToDictionary<TKey, TValue>( this string str, string keyValueSeperator = "|", string lineSeperator = "," )
        {
            var lineValues = str.Split( new[] { lineSeperator }, StringSplitOptions.RemoveEmptyEntries );

            return lineValues.Select( line =>
            {
                var keyValuePair = line.Split( new[] { keyValueSeperator }, StringSplitOptions.RemoveEmptyEntries );

                return keyValuePair.Length == 2
                    ? new KeyValuePair<TKey, TValue>( str.Cast<TKey>(), str.Cast<TValue>() )
                    : new KeyValuePair<TKey, TValue>( default( TKey ), default( TValue ) );
            } )
            .ToDictionary( kvp => kvp.Key, kvp => kvp.Value );
        }

        /// <summary>
        /// Tries to convert a string into a Dictionaty
        /// </summary>
        /// <typeparam name="TKey">Key data type</typeparam>
        /// <typeparam name="TValue">Value data type</typeparam>
        /// <returns>Returnes a Dictionary of the desired type.</returns>
        public static IDictionary<TKey, TValue> ToDictionaryTrim<TKey, TValue>(this string str, string keyValueSeperator = "|", string lineSeperator = ",")
        {
            var lineValues = str.Split(new[] { lineSeperator }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim());

            var result = lineValues.Select(line =>
            {
                var keyValuePair = line.Split(new[] { keyValueSeperator }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).ToArray();            

                return keyValuePair.Length == 2
                    ? new KeyValuePair<TKey, TValue>(keyValuePair[0].Cast<TKey>(), keyValuePair[1].Cast<TValue>())
                    : new KeyValuePair<TKey, TValue>(default(TKey), default(TValue));
            });
            return result.ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
        }

        /// <summary>
        /// Will add ellipses to the given string if it exceeds a specific length.  
        /// </summary>
        /// <param name="str">The string</param>
        /// <param name="maxCharacters">Max number of characters before adding ellipses.</param>
        /// <param name="ellipsesText">The text of ellipses to use.</param>
        /// <returns>Example: "Long str..."</returns>
        public static string Ellipses( this string str, int maxCharacters, string ellipsesText = "..." )
        {
            var length = str.Length;

            return length > maxCharacters
                ? string.Format( "{0}{1}", str.Substring( 0, maxCharacters ), ellipsesText )
                : str;
        }

        public static string PascalCaseToDescription(this string str)
        {
            return str == null ? null : Regex.Replace(str, "(\\B[A-Z])", " $1");
        }

        public static string DescriptionToPascalCase(this string str)
        {
            var result = str.Replace(" ", "");
            return result.PascalCaseToDescription() == str ? result : str;
        }

        public static string NullableTrim(this string value)
        {
            return value == null ? null : value.Trim();
        }
        public static string IsNull(this string value, string defaultValue)
        {
            return value ?? defaultValue;
        }

        public static string TruncateLongString(this string str, int maxLength)
        {
            return str.Substring(0, Math.Min(str.Length, maxLength));
        }

        public static bool IsNumeric(this string input)
        {
            int test;
            return (!string.IsNullOrWhiteSpace(input)) && int.TryParse(input, out test);            
        }

        public static string CamelCase(this string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return input;
            if (input.Length == 1)
                return input.ToLower();
            return Char.ToLower(input[0]) + input.Substring(1);
        }

        public static string CamelCaseAllowSpace(this string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return input;
            if (input.Length == 1)
                return input.ToLower();
            var inputs = input.Split(' ');
            if (inputs.Length == 1)
                return Char.ToUpper(input[0]) + input.Substring(1).ToLower();
            else
            {
                var res = "";
                for (var i = 0; i < inputs.Length; i++)
                {
                    var inp = inputs[i];
                    if (res != "") res += " ";
                    if (inp.Length <= 1) 
                        res += inp;
                    else
                        res += Char.ToUpper(inp[0]) + inp.Substring(1).ToLower();
                }
                return res;
            }
        }
        public static string NullOrWhiteSpaceTrim(this string value)
        {
            return string.IsNullOrWhiteSpace(value) ? null : value.Trim();
        }

        public static string[] ParseCsv(this string line, int start=0, char delimiter=',')
        {
            const char quote = '"';

            var isInside = false;

            var values = new List<string>();
            string currentStr = "";
            if (line != null && line.Length > start)
            {
                for (int i = start; i < line.Length; i++)
                {
                    if (line[i] == quote)
                    {
                        if (isInside)
                        {
                            if (line.Length > i + 1 && line[i + 1] == quote)
                            {
                                currentStr += quote;
                                i++;
                            }
                            else
                                isInside = false;
                        }
                        else
                            isInside = true;
                    }
                    else if (line[i] == delimiter && !isInside)
                    {
                        values.Add(currentStr);
                        currentStr = "";
                    }
                    else
                        currentStr += line[i];
                }
                values.Add(currentStr);
            }

            return values.ToArray();
        }

        public static string OmitIfNull(this string self, string ifValue)
        {
            if (ifValue == null)
                return string.Empty;
            return self;
        }
        public static string OmitIfNullOrWhiteSpace(this string self, string ifValue)
        {
            if (string.IsNullOrWhiteSpace(ifValue))
                return string.Empty;
            return self;
        }
        public static string OmitIfNullOrWhiteSpace(this string self, int? ifValue)
        {
            if (!ifValue.HasValue)
                return string.Empty;
            return self;
        }

        public static IEnumerable<IList<string>> ReadAsCsv(this string self)
        {
            if (string.IsNullOrWhiteSpace(self))
                return null;
            
            return CsvParser.Parse(self, ',', '"');

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="self">The string to be replaced.</param>
        /// <param name="regexPattern">The regex pattern to be used to search for</param>
        /// <param name="groupNames">the name of the groups in the regex pattern that need to be replaced.</param>
        /// <param name="getValue">The function to provide the replacement values for the group value found. this function has 3 arguments: <br />
        /// First argument is the regex group found based on the pattern passed. <br />
        /// Second argument is the name of the regex group. <br />
        /// Third argument is the value of the regex group. <br />
        /// The returned value of this function will be replace the third value found in the original string. If the return value is null, it will be ignored. 
        /// </param>
        /// <returns>A new string with the new values replaced the old one found in the groups passed in the regex pattern</returns>
        public static string ReplaceByRegexGroup(this string self, string regexPattern, string[] groupNames, Func<Group,string,string, string> getValue)
        {
            var cache=new Dictionary<int, string>();
            var message = self;
            var bytes = Encoding.UTF8.GetBytes(self);


            var totalNewLength = bytes.Length;
            //var sb=new StringBuilder(message);
            var matches = Regex.Matches(message, regexPattern);
            foreach (Match m in matches)
            {
                foreach (var groupName in groupNames)
                {
                    var g = m.Groups[groupName];
                    var stopId = g.Value;
                    var replaceLen = g.Length;
                    var newValue = getValue(g,groupName, stopId);
                    cache.Add(g.Index, newValue);
                    if (newValue != null)
                    {
                        var newLen = newValue.Length ;
                        totalNewLength += (newLen - replaceLen);
                    }
                }
            }

            var bytesCurrentPosition = 0;
            var newBytesCurrentPosition = 0;
            var newBytes = new byte[totalNewLength];

            foreach (Match m in matches)
            {
                foreach (var groupName in groupNames)
                {
                    var g = m.Groups[groupName];                    
                    var stopId = g.Value;
                    var replaceIndex = g.Index;
                    var newValue = cache[g.Index];
                    //var newValue = getValue(g, groupName, stopId);
                    if (newValue != null)
                    {
                        var copyLen = (replaceIndex - bytesCurrentPosition);
                        Array.Copy(bytes, bytesCurrentPosition, newBytes, newBytesCurrentPosition, copyLen);
                        bytesCurrentPosition = replaceIndex;
                        newBytesCurrentPosition += copyLen;

                        for (var i = 0; i < newValue.Length; i++)
                            newBytes[newBytesCurrentPosition + i] = (byte)newValue[i];

                        bytesCurrentPosition += stopId.Length;
                        newBytesCurrentPosition += newValue.Length;
                    }
                }
            }

            var lastCopyLen = (bytes.Length - bytesCurrentPosition);
            Array.Copy(bytes, bytesCurrentPosition, newBytes, newBytesCurrentPosition, lastCopyLen);

            message = Encoding.UTF8.GetString(newBytes);
            cache.Clear();
            return message;
        }

        /// <summary>
        /// Perform a global replacement on a string based on a provided regex pattern with the given comparison function
        /// </summary>
        /// <param name="self">String where the replacement operation is performed</param>
        /// <param name="regexPattern">String containing regex pattern that will determine which items need replacement</param>
        /// <param name="skipValues">String containing values that will not be processed during replacement process</param>
        /// <param name="replaceValue">Method doing the comparison between values</param>
        /// <returns>New string generated after running the transformation process</returns>
        public static string ReplaceWithRegex(this string self, string regexPattern, Func<string, string> replaceValue, string[] skipValues = null)
        {
            var cache = new Dictionary<int, string>();
            var message = self;
            var bytes = Encoding.UTF8.GetBytes(self);

            var totalNewLength = bytes.Length;
            var matches = Regex.Matches(message, regexPattern, RegexOptions.Compiled);

            foreach (Match m in matches)
            {
                if (skipValues != null && skipValues.Any(v => v.Equals(m.Groups[1].Value, StringComparison.InvariantCultureIgnoreCase))) continue;
                var g = m.Groups[1];
                var stopId = g.Value;
                var replaceLen = g.Length;
                var newValue = replaceValue(stopId);
                cache.Add(g.Index, newValue);
                if (newValue == null) continue;
                var newLen = newValue.Length;
                totalNewLength += (newLen - replaceLen);
            }

            var bytesCurrentPosition = 0;
            var newBytesCurrentPosition = 0;
            var newBytes = new byte[totalNewLength];

            foreach (Match m in matches)
            {
                if (skipValues != null && skipValues.Any(v => v.Equals(m.Groups[1].Value, StringComparison.InvariantCultureIgnoreCase))) continue;
                var g = m.Groups[1];
                var stopId = g.Value;
                var replaceIndex = g.Index;
                var newValue = cache[g.Index];
                if (newValue == null) continue;
                var copyLen = (replaceIndex - bytesCurrentPosition);
                Array.Copy(bytes, bytesCurrentPosition, newBytes, newBytesCurrentPosition, copyLen);
                bytesCurrentPosition = replaceIndex;
                newBytesCurrentPosition += copyLen;

                for (var i = 0; i < newValue.Length; i++)
                    newBytes[newBytesCurrentPosition + i] = (byte)newValue[i];

                bytesCurrentPosition += stopId.Length;
                newBytesCurrentPosition += newValue.Length;
            }

            var lastCopyLen = (bytes.Length - bytesCurrentPosition);
            Array.Copy(bytes, bytesCurrentPosition, newBytes, newBytesCurrentPosition, lastCopyLen);

            message = Encoding.UTF8.GetString(newBytes);
            cache.Clear();
            return message;
        }

        public static string EncodeUriComponent(this string self)
        {
            if (string.IsNullOrWhiteSpace(self))
                return self;
            return Uri.EscapeDataString(self);
        }

    }
}