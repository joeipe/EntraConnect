using EntraConnect.API.Services;
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
        private readonly IContactService _contactService;

        public ContactsController(
            ILogger<ContactsController> logger,
            IContactService contactService)
        {
            _logger = logger;
            _contactService = contactService;
        }

        [HttpGet()]
        public async Task<ActionResult> GetContacts()
        {
            //var data = JsonFileReader.Read<List<Contact>>(@"contact_seed.json", @"FakeData\");
            var data = await _contactService.GetContactsAsync();
            return Ok(data);
        }

        [HttpGet()]
        public async Task<ActionResult> GetEnvironment()
        {
            var result = await _contactService.GetEnvironmentAsync();
            return Ok(new
            {
                result.envName,
                result.JISecret
            });
        }
    }
}