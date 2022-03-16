using System;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;

using ACTransit.RestroomFinder.Web.Controllers.Base;
using ACTransit.RestroomFinder.Web.Models;
using ACTransit.RestroomFinder.Web.Infrastructure;
using ACTransit.RestroomFinder.Web.Services;
using System.Security.Principal;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    [Authorize]
    public class AccountController : BaseController
    {
        // GET: /Account/Login
        [AllowAnonymous]
        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "None")]
        public ActionResult Login(string returnUrl)
        {
            //Already authenticated
            if (Request.IsAuthenticated && !string.IsNullOrWhiteSpace(Common.CurrentUser))
            {
                if (!string.IsNullOrEmpty(returnUrl) && returnUrl.Equals("logoff", StringComparison.CurrentCultureIgnoreCase))
                    returnUrl = string.Empty;

                if (!string.IsNullOrEmpty(returnUrl))
                    return Redirect(returnUrl);
                return RedirectToAction("Index", "Restroom");
            }

            //Not authenticated yet but currently running in demo mode
            if (Common.IsAutologin && !returnUrl.Equals("logoff", StringComparison.CurrentCultureIgnoreCase))
            {
                var demoUser = Common.FormsCredentials.FirstOrDefault();
                return Login(new LoginViewModel { UserName = demoUser.Name, Password = demoUser.Password, RememberMe = false }, string.Empty);
            }

            ClearAuthData();

            ViewBag.ComesFromExpiredSession = !string.IsNullOrEmpty(Request.UrlReferrer?.ToString()) && returnUrl != null;
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }


        //
        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        public ActionResult Login(LoginViewModel model, string returnUrl)
        {
            const int rememberMeExpiresMinutes = 43200;  //30 days
            const int normalExpiresMinutes = 1440; //1 day;

            bool isAuthorized = false;

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            //Is the application configured to use Forms authentication?
            if (FormsAuthentication.IsEnabled)
            {
                //Forms authentication with embedded credentials as per configuration in Web.Config file
                if (Common.FormsCredentials.Any())
                {
                    isAuthorized = FormsAuthentication.Authenticate(model.UserName, model.Password) || Common.IsAutologin;
                }

                //Forms authentication with Memmbership API as per configuration in Web.Config file
                else
                {
                    isAuthorized = Membership.ValidateUser(model.UserName, model.Password);
                }
            }

            //Create cookie
            if (isAuthorized)
            {
                //Get user information
                EmployeeViewModel thisEmployee;

                using (var service = new EmployeeService())
                {
                    thisEmployee = service.GetEmployeeByLogin(model.UserName);
                }

                if (thisEmployee != null)
                {
                    if (thisEmployee.Active)
                    {
                        var expires = DateTime.Now.AddMinutes(model.RememberMe
                            ? rememberMeExpiresMinutes
                            : normalExpiresMinutes);

                        FormsAuthenticationTicket authTicket = new FormsAuthenticationTicket(
                            1,
                            model.UserName, //user id
                            DateTime.Now,
                            expires, // expiry
                            model.RememberMe, //do not remember
                            System.Web.Helpers.Json.Encode(thisEmployee),
                            HttpContext.Request.ApplicationPath);

                        //Encrypt ticket and add to cookie collection
                        HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, FormsAuthentication.Encrypt(authTicket));

                        if (!Common.IsAutologin)
                            cookie.Expires = expires;

                        Response.Cookies.Add(cookie);

                        Logger.WriteDebug($"ACTransit.RestromFinder.Web.AccountController.Login - User {model.UserName} logged in successfully as " +
                            $"{(TokenAuthorizationHelper.UserHasAccess(model.UserName, TokenAuthorizationHelper.TokenAdmin) ? "Admin" : string.Empty)} " +
                            $"{(TokenAuthorizationHelper.UserHasAccess(model.UserName, TokenAuthorizationHelper.TokenApplicationAccessEditor) ? " Application Access Editor" : string.Empty)}" +
                            $"{(TokenAuthorizationHelper.UserHasAccess(model.UserName, TokenAuthorizationHelper.TokenFeedbackEditor) ? " Feedback Editor" : string.Empty)}" +
                            $"{(TokenAuthorizationHelper.UserHasAccess(model.UserName, TokenAuthorizationHelper.TokenRestroomCreator) ? " Restroom Creator" : string.Empty)}" +
                            $"{(TokenAuthorizationHelper.UserHasAccess(model.UserName, TokenAuthorizationHelper.TokenRestroomEditor) ? " Restroom Editor" : string.Empty)}" +
                            $"");

                        return RedirectToLocal(returnUrl ?? string.Empty);
                    }

                    ModelState.AddModelError("", "This user has been disabled. Please contact your supervisor.");
                    Logger.WriteDebug($"ACTransit.RestromFinder.Web.AccountController.Login - User {model.UserName} is not currently in active status.");
                }
                else
                {
                    ModelState.AddModelError("", "User not found or has not been created.");
                    Logger.WriteDebug($"ACTransit.RestromFinder.Web.AccountController.Login - User credentials for {model.UserName} were not found in database.");
                }
            }
            else
            {
                ModelState.AddModelError("", "Invalid user name or password.");
                Logger.WriteDebug($"ACTransit.RestromFinder.Web.AccountController.Login - User credentials for {model.UserName} were not found in Active Directory.");
            }

            return View(model);
        }

        //
        // POST: /Account/LogOff
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            Logger.WriteDebug($"ACTransit.RestromFinder.Web.AccountController.LogOff - User {Common.CurrentUser} signed off.");
            ClearAuthData();
            return RedirectToAction("Index", "Restroom");
        }

        [HttpGet]
        [ActionName("LogOff")]
        public ActionResult EndSession()
        {
            Logger.WriteDebug($"ACTransit.RestromFinder.Web.AccountController.EndSession - User {Common.CurrentUser} signed off.");
            ClearAuthData();
            return RedirectToAction("Login", "Account");
        }

        #region Helpers

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl) && !returnUrl.Contains("LogOut"))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Restroom");
        }

        private void ClearAuthData()
        {
            //Clear session data
            FormsAuthentication.SignOut();
            Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Session.Abandon();

            //Clear authentication cookie
            HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, "")
            {
                Expires = DateTime.Now.AddYears(-1),
                Path = Request.ApplicationPath
            };

            Response.Cookies.Add(authCookie);

            HttpContext.User = new GenericPrincipal(new GenericIdentity(string.Empty), null);
        }

        internal class ChallengeResult : HttpUnauthorizedResult
        {
            public ChallengeResult(string provider, string redirectUri)
                : this(provider, redirectUri, null)
            {
            }

            public ChallengeResult(string provider, string redirectUri, string userId)
            {
                LoginProvider = provider;
                RedirectUri = redirectUri;
                UserId = userId;
            }

            public string LoginProvider { get; set; }
            public string RedirectUri { get; set; }
            public string UserId { get; set; }
        }

        #endregion
    }
}