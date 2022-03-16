using System;
using ACTransit.DataAccess.Employee.Repositories;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.Framework.Logging;

namespace ACTransit.RestroomFinder.API.Services
{
    internal abstract class BaseService : IDisposable
    {
        private EmployeeRepository _employeeRepository;
        //private RestroomContext _restroomRepository;
        private RestroomUnitOfWork _restroomUnitOfWork;

        protected internal EmployeeRepository EmployeeRepository => _employeeRepository ?? (_employeeRepository = new EmployeeRepository());
        //protected RestroomContext RestroomRepository => _restroomRepository ?? (_restroomRepository = new RestroomContext());
        protected internal RestroomUnitOfWork RestroomUnitOfWork=> _restroomUnitOfWork ?? (_restroomUnitOfWork = new RestroomUnitOfWork());

        private Logger _logger;
        public Logger Logger => _logger ?? (_logger = new Logger(GetType()));

        public void Dispose()
        {
            _employeeRepository?.Dispose();
            _restroomUnitOfWork?.Dispose();
            //_restroomRepository?.Dispose();
        }
    }
  
}