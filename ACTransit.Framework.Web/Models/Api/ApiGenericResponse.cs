namespace ACTransit.Framework.Web.Models.Api
{    
    public class ApiGenericResponse<T>
    {
        public T Value { get; set; }
        public string Error { get; set; }     
        public int ErrorType { get; set; }
        public string Tag { get; set; }
    }
}
