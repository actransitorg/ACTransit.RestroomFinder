using ACTransit.Framework.DataAccess;

namespace ACTransit.DataAccess.Scheduling.Repositories
{
    public class SchedulingUnitOfWork : UnitOfWorkBase<SchedulingEntities>
    {
        public SchedulingUnitOfWork() : this(new SchedulingEntities(), null) { }
        public SchedulingUnitOfWork(SchedulingEntities context) : this(context, null) { }
        public SchedulingUnitOfWork(string currentUserName) : this(new SchedulingEntities(), currentUserName) { }
        public SchedulingUnitOfWork(SchedulingEntities context, string currentUserName) : base(context) { CurrentUserName = currentUserName; }
    }

    public class SchedulingReadOnlyUnitOfWork : ReadOnlyUnitOfWorkBase<SchedulingEntities>
    {
        public SchedulingReadOnlyUnitOfWork() : this(new SchedulingEntities()) { }
        public SchedulingReadOnlyUnitOfWork(SchedulingEntities context) : base(context) { }
    }
}
