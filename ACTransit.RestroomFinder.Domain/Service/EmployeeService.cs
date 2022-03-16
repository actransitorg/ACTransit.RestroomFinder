using System;
using System.Collections.Generic;
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

        public List<Dto.Employee> GetEmployees(string badge = null,
                                                string name = null, string firstName = null, string lastName = null, string middleName = null, DateTime? birthDate = null,
                                                string address = null,
                                                string homePhone = null, string workPhone = null, string cellPhone = null, string email = null,
                                                string deptName = null, string jobTitle = null, string ntLogin = null)
        {
            using (var repository = new EmployeeRepository())
            {
                return repository.GetEmployees(badge,
                                        name,
                                        firstName,
                                        lastName,
                                        middleName,
                                        birthDate,
                                        address,
                                        homePhone,
                                        workPhone,
                                        cellPhone,
                                        email,
                                        deptName,
                                        jobTitle,
                                        ntLogin
                                        )
                    .Select(Converter.ToModel)
                    .ToList();
            }
        }

        public List<Dto.Employee> GetEmployees(string[] lanIds)
        {
            return _employeeRepository
                    .GetEmployees(lanIds)
                    .Select(Converter.ToModel)
                    .ToList();
        }


        public Dto.Employee GetEmployeeByLogin(string login)
        {
            var employee = _employeeRepository
                            .GetEmployees(new[] { login })
                            .FirstOrDefault();

            return Converter.ToModel(employee);
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
