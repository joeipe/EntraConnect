using Azure.Extensions.AspNetCore.Configuration.Secrets;
using Azure.Identity;
using EntraConnect.API.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

/*
if (!builder.Environment.IsDevelopment())
{
    var keyVaultName = builder.Configuration["KeyVaultName"];
    var options = new AzureKeyVaultConfigurationOptions { ReloadInterval = TimeSpan.FromHours(24) };
    builder.Configuration
        .AddAzureKeyVault(new Uri($"https://{keyVaultName}.vault.azure.net/"), new DefaultAzureCredential(), options);
}
*/

// Add services to the container.
builder.Services.AddScoped<IContactService, ContactService>();

builder.Services.AddControllers();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, options =>
    {
        options.Authority = builder.Configuration["AzureAD:Authority"];
        options.Audience = builder.Configuration["AzureAD:Audience"];
        /*
        options.TokenValidationParameters = new TokenValidationParameters
        {
            //ValidIssuers = new[] {
            //    //"https://login.microsoftonline.com/919b1bc0-86f7-4318-ae44-edbf236decf8/v2.0",
            //    "https://919b1bc0-86f7-4318-ae44-edbf236decf8.ciamlogin.com/919b1bc0-86f7-4318-ae44-edbf236decf8/v2.0"
            //},
            ValidAudiences = new[] {
                "api://df2928cf-8d96-4a83-bdbe-c89f8c877ab3",
                "df2928cf-8d96-4a83-bdbe-c89f8c877ab3"
            }
        };
        */
        options.TokenValidationParameters.ValidateIssuer = false;
    });

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo { Title = "EntraConnect API", Version = $"1.0" });
    options.AddSecurityDefinition("EntraConnectApiBearerAuth", new OpenApiSecurityScheme()
    {
        Type = SecuritySchemeType.Http,
        Scheme = "Bearer",
        Description = "Input a valid token to access this API"
    });
    options.AddSecurityRequirement(new OpenApiSecurityRequirement()
                {
                    {
                         new OpenApiSecurityScheme()
                         {
                             Reference = new OpenApiReference
                             {
                                 Type = ReferenceType.SecurityScheme,
                                 Id = "EntraConnectApiBearerAuth"
                             }
                         }, new List<string>()
                    }
                });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
//if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();