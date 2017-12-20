using System;
using System.Linq;

using ACTransit.DataAccess.Employee.Repositories;
using ACTransit.RestroomFinder.Domain.Infrastructure;

namespace ACTransit.RestroomFinder.Domain.Service
{
    public class EmployeeService: IDisposable
    {
        private bool _disposed;
        private const string Classname = "EmployeeService";

        private readonly EmployeeRepository _employeeRepository;

        public EmployeeService()
        {
            _employeeRepository = new EmployeeRepository();
        }


        public Dto.Employee GetEmployeeByLogin(string login)
        {
            return _employeeRepository.GetEmployees(ntLogin: login).Select(Converter.ToModel).FirstOrDefault();
        }

        #region IDisposable Implementation

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
                return;

            if (disposing)
            {
               _employeeRepository.Dispose();
            }

            _disposed = true;
        }

        #endregion
    }
}
