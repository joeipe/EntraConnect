using EntraConnect.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EntraConnect.API.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    [Authorize]
    public class ContactsController : ControllerBase
    {
        private readonly ILogger<ContactsController> _logger;

        public ContactsController(
            ILogger<ContactsController> logger)
        {
            _logger = logger;
        }

        [HttpGet()]
        public async Task<ActionResult> GetContacts()
        {
            //var data = JsonFileReader.Read<List<Contact>>(@"contact_seed.json", @"FakeData\");
            var data = await Task.FromResult(new List<Contact> { new Contact { Id = 1, FirstName = "Joe", LastName = "Ipe", DoB = "26/04/1981" } });
            return Ok(data);
        }
    }
}