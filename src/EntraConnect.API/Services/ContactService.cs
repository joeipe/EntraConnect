using EntraConnect.API.Models;

namespace EntraConnect.API.Services
{
    public class ContactService : IContactService
    {
        private readonly IConfiguration _configuration;

        public ContactService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<List<Contact>> GetContactsAsync()
        {
            var data = await Task.FromResult(new List<Contact> { new Contact { Id = 1, FirstName = "Joe", LastName = "Ipe", DoB = "26/04/1981" } });
            return data;
        }

        public async Task<(string envName, string JISecret)> GetEnvironmentAsync()
        {
            var envName = await Task.FromResult(_configuration["EnvironmentName"]);
            var jiSecret = await Task.FromResult(_configuration["JISecret"]);
            return (envName, jiSecret);
        }
    }
}