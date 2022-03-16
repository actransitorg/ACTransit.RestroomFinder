using System;
using System.ComponentModel;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace ACTransit.Framework.Extensions
{
    public static class NameValueCollectionExtensions
    {
        /// <summary>
        ///     A NameValueCollection extension method that converts the @this to a dictionary.
        /// </summary>
        /// <param name="source">The source to act on</param>
        /// <returns>source as an IDictionary</returns>
        public static IDictionary<string, TValue> ToDictionary<TValue>(this NameValueCollection source)
        {
            var dict = new Dictionary<string, TValue>();

            if (source == null)
                throw new ArgumentNullException("Unable to convert object to a dictionary. The source object is null.");

            var valueConverter = TypeDescriptor.GetConverter(typeof(TValue));

            foreach (string key in source.AllKeys)
            {
                try
                {
                    dict.Add(key, (TValue)valueConverter.ConvertFromString(source[key]));
                }
                catch
                {
                    dict.Add(key, default);
                }
            }

            return dict;
        }
    }
}
