namespace EntraConnect.API.Models
{
    public class Contact
    {
        public int Id { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string DoB { get; set; }
    }
}
