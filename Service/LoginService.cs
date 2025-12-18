using LMS.Model;
using LMS.Repository;

namespace LMS.Service
{
    public class LoginService
    {
        private readonly LoginRepository _loginRepository;

        public LoginService()
        {
            _loginRepository = new LoginRepository();
        }

        public LoginResult Login(string email, string password)
        {
            return _loginRepository.ValidateLogin(email, password);
        }
    }
}
