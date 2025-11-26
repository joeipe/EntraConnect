using EntraConnect.API.Models;

namespace EntraConnect.API.Services
{
    public interface IContactService
    {
        Task<List<Contact>> GetContactsAsync();

        Task<(string envName, string JISecret)> GetEnvironmentAsync();
    }
}