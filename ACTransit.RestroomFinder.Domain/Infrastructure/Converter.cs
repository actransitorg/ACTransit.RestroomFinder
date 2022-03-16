using ACTransit.DataAccess.RestroomFinder.Interfaces;
using ACTransit.Framework.Interfaces;
using ACTransit.RestroomFinder.Domain.Enums;
using System;
using System.Linq;
using DBE = ACTransit.Entities.Employee;
using DBR = ACTransit.DataAccess.RestroomFinder;

namespace ACTransit.RestroomFinder.Domain.Infrastructure
{
    public static class Converter
    {
        public static Dto.Employee ToModel(DBE.Employee employee)
        {
            if (employee == null) return null;

            return new Dto.Employee
            {
                EmployeeId = employee.Emp_Id,
                Name = employee.Name,
                FirstName = employee.FirstName,
                LastName = employee.LastName,
                NtLogin = employee.NTLogin,
                Active = employee.Empl_Status == "A",
                Badge = employee.Badge,
                Email = employee.EmailAddress,
                Phone = employee.WorkPhone,
                JobTitle = employee.JobTitle
            };
        }

        public static Dto.User ToModel(DBR.V_User user)
        {
            if (user == null) return null;

            return new Dto.User
            {
                UserId = user.UserId,
                Name = user.Name,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Phone = user.PreferredPhone,
                JobTitle = user.JobTitle,
                Badge = user.Badge,
                Description = user.UserDescription,
                LastLogon = user.LastLogon ?? DateTime.MinValue,
                LastLogonDeviceGuid = user.DeviceGuid,
                LastLogonDeviceModel = user.DeviceModel,
                LastLogonDeviceOS = user.DeviceOS,
                NumberOfActiveDevices = user.NumberOfActiveDevices,
                Active = user.UserActive,
            };
        }

        public static Dto.Device ToModel(DBR.Device device)
        {
            if (device == null) return null;

            return new Dto.Device
            {
                DeviceId = device.DeviceId,
                Active = device.Active,
                DeviceGuid = device.DeviceGuid,
                DeviceModel = device.DeviceModel,
                DeviceOS = device.DeviceModel,
                DeviceSessionId = device.DeviceSessionId,
                LastUsed = device.LastUsed,
                Description = device.Description
            };
        }

        public static Dto.UserDevice ToModel(DBR.V_UserDevice userDevice)
        {
            if (userDevice == null) return null;

            return new Dto.UserDevice
            {
                Name = userDevice.Name,
                Badge = userDevice.Badge,
                FirstName = userDevice.FirstName,
                LastName = userDevice.LastName,
                JobTitle = userDevice.JobTitle,
                Active = userDevice.UserDeviceActive,
                DeviceActive = userDevice.DeviceActive,
                CanUse = userDevice.DeviceActive && userDevice.UserActive && userDevice.UserDeviceActive,
                UserId = userDevice.UserId,
                DeviceId = userDevice.DeviceId,
                DeviceGuid = userDevice.DeviceGuid,
                DeviceModel = userDevice.DeviceModel,
                DeviceOS = userDevice.DeviceOS,
                DeviceSessionId = userDevice.DeviceSessionId,
                LastLogon = userDevice.LastLogon,
                Description = userDevice.DeviceDescription
            };
        }

        public static Dto.Restroom ToModel(IRestroom restroom)
        {
            if (restroom == null) return null;

            var newRestroom = new Dto.Restroom
            {
                RestroomId = restroom.RestroomId,
                ContactId = restroom.ContactId ?? 0,
                EquipmentNum = restroom.EquipmentNum,
                RestroomType = restroom.RestroomType,
                RestroomName = restroom.RestroomName,
                Address = restroom.Address,
                City = restroom.City,
                State = restroom.State,
                Zip = restroom.Zip,
                Country = restroom.Country,
                DrinkingWater = restroom.DrinkingWater,
                ACTRoute = restroom.ACTRoute,
                WeekdayHours = restroom.WeekdayHours,
                SaturdayHours = restroom.SaturdayHours,
                SundayHours = restroom.SundayHours,
                Note = restroom.Note,
                NearestIntersection = restroom.NearestIntersection,
                LongDec = restroom.LongDec,
                LatDec = restroom.LatDec,
                Geo = restroom.Geo,
                NotificationEmail = restroom.NotificationEmail,
                CleanedContactId = restroom.CleanedContactId,
                RepairedContactId = restroom.RepairedContactId,
                SuppliedContactId = restroom.SuppliedContactId,
                SecurityGatesContactId = restroom.SecurityGatesContactId,
                SecurityLocksContactId = restroom.SecurityLocksContactId,
                IsToiletAvailable = restroom.IsToiletAvailable,
                //Active = restroom.Active,
                ToiletGenderId = restroom.ToiletGenderId,
                AddressChanged = restroom.AddressChanged ?? false,
                LabelId = restroom.LabelId,
                Deleted = restroom.Deleted,
                IsHistory = restroom.IsHistory,
                IsPublic = restroom.IsPublic,
                UnavailableFrom = restroom.UnavailableFrom,
                UnavailableTo = restroom.UnavailableTo,
                Comment = null,
                StatusListId = restroom.StatusListId ?? (int)RestroomEnums.RestroomApprovalStatus.Pending
            };

            //Look for specific properties for restroom class variations
            /*if (restroom is IPendingReview review)
                newRestroom.PendingReview = review.PendingReview;*/

            if (restroom is IRestroomModifier modifier)
            {
                newRestroom.AddUserName = modifier.AddUserName;
                newRestroom.UpdUserName = modifier.UpdUserName;
            }

            if (restroom is IHistoryVersion version)
            {
                newRestroom.SysStartTime = version.SysStartTime;
                newRestroom.SysEndTime = version.SysEndTime;
            }

            if (restroom is IAuditableEntity audit)
            {
                newRestroom.AddUserId = audit.AddUserId;
                newRestroom.AddDateTime = audit.AddDateTime;
                newRestroom.UpdUserId = audit.UpdUserId;
                newRestroom.UpdDateTime = audit.UpdDateTime;
            }

            return newRestroom;
        }

        public static DBR.Restroom ToEntity(Dto.Restroom restroom)
        {
            if (restroom == null) return null;

            var newRestroom = new DBR.Restroom
            {
                RestroomId = restroom.RestroomId,
                ContactId = restroom.ContactId == 0 ? null : restroom.ContactId,
                EquipmentNum = restroom.EquipmentNum,
                RestroomType = restroom.RestroomType,
                RestroomName = restroom.RestroomName,
                Address = restroom.Address,
                City = restroom.City,
                State = restroom.State,
                Zip = restroom.Zip,
                Country = restroom.Country,
                DrinkingWater = restroom.DrinkingWater,
                WeekdayHours = restroom.WeekdayHours,
                SaturdayHours = restroom.SaturdayHours,
                SundayHours = restroom.SundayHours,
                Note = restroom.Note,
                NearestIntersection = restroom.NearestIntersection,
                LongDec = restroom.LongDec,
                LatDec = restroom.LatDec,
                NotificationEmail = restroom.NotificationEmail,
                CleanedContactId = restroom.CleanedContactId == 0 ? null : restroom.CleanedContactId,
                RepairedContactId = restroom.RepairedContactId == 0 ? null : restroom.RepairedContactId,
                SuppliedContactId = restroom.SuppliedContactId == 0 ? null : restroom.SuppliedContactId,
                SecurityGatesContactId = restroom.SecurityGatesContactId == 0 ? null : restroom.SecurityGatesContactId,
                SecurityLocksContactId = restroom.SecurityLocksContactId == 0 ? null : restroom.SecurityLocksContactId,
                IsToiletAvailable = restroom.IsToiletAvailable,
                //Active = restroom.Active,
                ToiletGenderId = restroom.ToiletGenderId,
                AddressChanged = restroom.AddressChanged,
                LabelId = restroom.LabelId,
                StatusListId = restroom.StatusListId,
                Deleted = restroom.Deleted,
                IsHistory = restroom.IsHistory,
                IsPublic = restroom.IsPublic,
                UnavailableFrom = restroom.UnavailableFrom,
                UnavailableTo = restroom.UnavailableTo,
                Comment = restroom.Comment
            };

            //Create geography object for the current location
            newRestroom.Geo = System.Data.Entity.Spatial.DbGeography.PointFromText(
                $"POINT({restroom.LongDec} {restroom.LatDec})", 4326);

            //Transform string array of routes into a comma separated values string
            if (restroom.SelectedRoutes != null && restroom.SelectedRoutes.Count() > 0)
                newRestroom.ACTRoute = string.Join(",", restroom.SelectedRoutes);
            else
                newRestroom.ACTRoute = restroom.ACTRoute;

            return newRestroom;
        }

        public static Dto.RestroomHistory ToModel(DBR.RestroomHistory restroom)
        {
            if (restroom == null) return null;

            var newRestroom = new Dto.RestroomHistory
            {
                RestroomId = restroom.RestroomId,
                ContactId = restroom.ContactId ?? 0,
                EquipmentNum = restroom.EquipmentNum,
                RestroomType = restroom.RestroomType,
                RestroomName = restroom.RestroomName,
                Address = restroom.Address,
                City = restroom.City,
                State = restroom.State,
                Zip = restroom.Zip,
                Country = restroom.Country,
                DrinkingWater = restroom.DrinkingWater,
                ACTRoute = restroom.ACTRoute,
                WeekdayHours = restroom.WeekdayHours,
                SaturdayHours = restroom.SaturdayHours,
                SundayHours = restroom.SundayHours,
                Note = restroom.Note,
                NearestIntersection = restroom.NearestIntersection,
                LongDec = restroom.LongDec,
                LatDec = restroom.LatDec,
                Geo = restroom.Geo,
                NotificationEmail = restroom.NotificationEmail,
                IsToiletAvailable = restroom.IsToiletAvailable,
                //Active = restroom.Active,
                ToiletGenderId = restroom.ToiletGenderId,
                AddressChanged = restroom.AddressChanged,
                Deleted = restroom.Deleted,
                IsHistory = restroom.IsHistory,
                IsPublic = restroom.IsPublic,
                UnavailableFrom = restroom.UnavailableFrom,
                UnavailableTo = restroom.UnavailableTo,
                StatusListId = restroom.StatusListId ?? (int)RestroomEnums.RestroomApprovalStatus.Pending,
                Comment = restroom.Comment,
                ServiceProvider = restroom.ServiceProvider,
                ContactName = restroom.ContactName,
                ContactTitle = restroom.ContactTitle,
                ContactPhone = restroom.ContactPhone,
                ContactEmail = restroom.ContactEmail,
                CleanedServiceProvider = restroom.CleanedServiceProvider,
                RepairedServiceProvider = restroom.RepairedServiceProvider,
                SuppliedServiceProvider = restroom.SuppliedServiceProvider,
                SecurityGateServiceProvider = restroom.SecurityGateServiceProvider,
                SecurityLocksServiceProvider = restroom.SecurityLocksServiceProvider,
                ContactAddress = restroom.ContactAddress,
                ContactNotes = restroom.ContactNotes,
                UpdUserId = restroom.UpdUserId,
                UpdDateTime = restroom.UpdDateTime
            };

            return newRestroom;
        }

        public static Dto.RestroomContactReport ToModel(DBR.RestroomContactReport restroom)
        {
            if (restroom == null) return null;

            var newRestroom = new Dto.RestroomContactReport()
            {
                RestroomId = restroom.RestroomId,
                RestroomName = restroom.RestroomName,
                LabelId = restroom.LabelId,
                Status = restroom.Status,
                OwnedServiceProvider = restroom.OwnedServiceProvider,
                OwnedContactId = restroom.OwnedContactId,
                CleanedServiceProvider = restroom.CleanedServiceProvider,
                CleanedContactId = restroom.CleanedContactId,
                RepairedServiceProvider = restroom.RepairedServiceProvider,
                RepairedContactId = restroom.RepairedContactId,
                SuppliedServiceProvider = restroom.SuppliedServiceProvider,
                SuppliedContactId = restroom.SuppliedContactId,
                SecurityGateServiceProvider = restroom.SecurityGateServiceProvider,
                SecurityGateContactId = restroom.SecurityGateContactId,
                SecurityLockServiceProvider = restroom.SecurityLockServiceProvider,
                SecurityLockContactId = restroom.SecurityLockContactId
            };

            return newRestroom;
        }

        public static Dto.Contact ToModel(DBR.Contact contact)
        {
            if (contact == null) return null;

            return new Dto.Contact
            {
                ContactId = contact.ContactId,
                ServiceProvider = contact.ServiceProvider,
                Name = contact.ContactName,
                Title = contact.Title,
                Phone = contact.Phone,
                Email = contact.Email,
                Address = contact.Address,
                Notes = contact.Notes
            };
        }

        public static Dto.RestroomContact ToModel(DBR.RestroomContact contact)
        {
            if (contact == null) return null;

            return new Dto.RestroomContact
            {
                ContactId = contact.ContactId,
                ServiceProvider = contact.ServiceProvider,
                Name = contact.ContactName,
                Title = contact.Title,
                Phone = contact.Phone,
                Email = contact.Email,
                Address = contact.Address,
                HasRestroom = contact.HasRestroom,
                Notes = contact.Notes
            };
        }

        public static DBR.Contact ToEntity(Dto.Contact contact)
        {
            if (contact == null) return null;

            var newContact = new DBR.Contact
            {
                ContactId = contact.ContactId,
                ServiceProvider = contact.ServiceProvider,
                ContactName = contact.Name,
                Title = contact.Title,
                Email = contact.Email,
                Address = contact.Address,
                Phone = contact.Phone,
                Notes = contact.Notes
            };

            return newContact;
        }
        public static Dto.Feedback ToModel(DBR.Feedback entity)
        {
            if (entity == null) return null;

            return new Dto.Feedback
            {
                RestroomId = entity.RestroomId,
                Badge = entity.Badge,
                FeedbackId = entity.FeedbackId,
                FeedbackText = entity.FeedbackText,
                Issue = entity.Issue,
                InspectionPassed = entity.InspectionPassed ?? false,
                NeedsAttention = entity.NeedAttention,
                NeedsCleaning = entity.NeedCleaning,
                NeedsRepair = entity.NeedRepair,
                NeedsSupply = entity.NeedSupply,
                Rating = entity.Rating,
                Resolution = entity.Resolution,
                ReportedAction = entity.ReportedAction,
                AddDateTime = entity.AddDateTime,
                UpdDateTime = entity.UpdDateTime
            };
        }

        public static DBR.Feedback ToEntity(Dto.Feedback model)
        {
            if (model == null) return null;

            return new DBR.Feedback
            {
                RestroomId = model.RestroomId,
                Badge = model.Badge,
                FeedbackId = model.FeedbackId,
                FeedbackText = model.FeedbackText,
                Issue = model.Issue,
                InspectionPassed = model.InspectionPassed ?? false,
                NeedAttention = model.NeedsAttention,
                NeedCleaning = model.NeedsCleaning,
                NeedRepair = model.NeedsRepair,
                NeedSupply = model.NeedsSupply,
                Rating = model.Rating,
                Resolution = model.Resolution,
                ReportedAction = model.ReportedAction
            };
        }
    }
}
