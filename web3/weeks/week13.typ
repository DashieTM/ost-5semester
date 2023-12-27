#import "../../utils.typ": *

#subsection("Validation")
You can notate your C\# classes with requirements which will be checked against
on input:
```cs
public class NewOrderViewModel {
  [StringLength(MinimumLength = 3)]
  [Required]
  public string Name { get; set; }
}
```
The following tags are possible:
- [StringLength(60, MinimumLength = 3)]
- [RegularExpression(@\"^[A-Z]+[a-zA-Z''-'\s]\*\$\")]
- [Required]
- [DataType(DataType.Date)]

After that you would have to put this into your HTML in order for your binding
to take effect:
```asp
<div asp-validation-summary="ModelOnly" class="text-danger"></div>
<div class="form-group">
  <label asp-for="Item.Name" class="control-label"></label>
  <input asp-for="Item.Name" class="form-control" />
  <span asp-validation-for="Item.Name" class="text-danger"></span>
</div>
<div class="form-group">
  <input type="submit" value="Create" class="btn btn-primary" />
</div>
```
```cs
[HttpPost]
public ActionResult Index(Order order)
{
if (ModelState.IsValid)
{
order.CustomerId = User.Identity.GetUserId();
_db.Orders.Add(order);
_db.SaveChanges();
return View("OrderOk", order);
}
return BadRequest();
}
```

And in order to provide direct error handling for the user, also include the
validation on the client side with JQuery:

```asp
@section Scripts {
  <script src="~/lib/jquery-validation/dist/jquery.validate.js"></script>
  <script src="~/lib/jquery-validation-unobtrusive/jquery.validate.unobtrusive.js"></script>
}
```
#align(
  center, [#image("../../Screenshots/2023_12_22_10_41_59.png", width: 80%)],
)

#subsection("Routing")
Routing also works with tags:
```asp
[Route("api/[controller]")]
public class ValuesController : Controller
{
[HttpGet]
public IEnumerable<Value> Get()
{
return _valueService.All();
}
[HttpGet("{id}")]
public Value Get(int id)
{
return _valueService.Get(id); ;
}
[HttpPost]
public void Post([FromBody]Value value)
{
_valueService.Add(value);
}
/ ...
}
```

Routes themselves can directly be configured on the actions themselves:
#align(
  center, [#image("../../Screenshots/2023_12_22_10_45_53.png", width: 80%)],
)

The location header should be set appropriately:

#align(
  center, [#image("../../Screenshots/2023_12_22_10_47_36.png", width: 40%)],
)

```cs
[HttpPost]
public IActionResult Post([FromBody]Value value)
{
value = _valueService.Add(value);
return new CreatedAtActionResult("Get", "Values", new {id = _valueService.GetId(value)}, value);
}
```

#subsection("Swagger")
- programming language independent
- a specification for the documentation of REST APIs
- Swagger UI and Swagger codegen -> tools to generate API
- implementations for nearly every programming language

In asp, swagger can be registered at startup:
```cs
public void ConfigureServices(IServiceCollection services)
{
services.AddSwaggerGen();
services.AddMvc();
}
public void Configure(IApplicationBuilder app, IHostingEnvironment env)
{
app.UseSwagger();
app.UseSwaggerUI(options =>
{
options.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
});
app.UseMvc();
}
```

Example usage:
#align(
  center, [#image("../../Screenshots/2023_12_22_10_50_37.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_22_10_51_23.png", width: 100%)],
)

Just like with Rustdoc, you can generate comments inside swagger via an XML
export, which happens with three /:
```cs
/// <summary>
/// Gets all values.
/// </summary>
/// <remarks>
/// This rest api is not thread-save. Please call only once every hour!
/// </remarks>
/// <returns></returns>
/// <response code="201">Returns the list of items</response>
/// <response code="400">If no item is there</response>
[ProducesResponseType(typeof(IEnumerable<string>), 201)]
[ProducesResponseType(typeof(void), 400)]
[HttpGet]
public IEnumerable<string> Get()
{
return _valueService.All();
}
```
#align(
  center, [#image("../../Screenshots/2023_12_22_10_53_01.png", width: 80%)],
)

#subsection("Exception Handling")
As .not is actually a shit language, we ofc need exception exception. Here we go
with the dual fuckery of a global handler for exceptions.
```cs
public enum ServiceExceptionType {
Unkown = HttpStatusCode.InternalServerError,
NotFound = HttpStatusCode.NotFound,
Duplicated = HttpStatusCode.BadRequest,
}

public class ServiceException : Exception {
public ServiceExceptionType Type { get; private set; }
public ServiceException(ServiceExceptionType type){
Type = type;
}
}

public Value Get(int id) {
if (Values.Count > id && Values[id] != null) {
return Values[id];
}
throw new ServiceException(ServiceExceptionType.NotFound);
}
```

Exception usage:
```cs
app.UseExceptionHandler(errorApp =>
{
errorApp.Run(async context =>
{
var errorFeature = context.Features.Get<IExceptionHandlerFeature>();
var exception = errorFeature.Error as ServiceException;
var metadata = new
{
Message = "An unexpected error occurred! The error ID will be helpful to debug the problem",
DateTime = DateTimeOffset.Now,
RequestUri = new Uri(context.Request.Host.ToString() + context.Request.Path.ToString() + context.Request.QueryString),
Type = exception?.Type ?? ServiceExceptionType.Unkown,
ExceptionMessage = exception?.Message,
ExceptionStackTrace = exception?.StackTrace
};
context.Response.ContentType = "application/json";
context.Response.StatusCode = exception != null ? (int)exception.Type : (int)HttpStatusCode.InternalServerError;
await context.Response.WriteAsync(JsonConvert.SerializeObject(metadata));
});
});
```
#align(
  center, [#image("../../Screenshots/2023_12_22_11_25_22.png", width: 80%)],
)

And you can filter for state in order to do the new new exception..
```cs
services.AddMvc(options =>
{
options.Filters.Add(new ValidateModelAttribute());
});
public class ValidateModelAttribute : ActionFilterAttribute
{
public override void OnActionExecuting(ActionExecutingContext context)
{
if (!context.ModelState.IsValid)
{
throw new ServiceException(ServiceExceptionType.ForbiddenByRule);
}
}
}
```

#subsection("Authentication")
Just like angufuck, you can inject services in order to provide authentication,
however unlike angufuck, there are some that are predefined:
- UserManager\<ApplicationUser\>\
- RoleManager\<IdentityRole\>\
- IAuthorizationService
- SignInManager

Configuration can be done on startup:
```cs
services.AddDefaultIdentity<IdentityUser>(
options =>
{
options.Password.RequireDigit = false;
options.Password.RequireLowercase = false;
options.Password.RequireNonAlphanumeric = false;
options.Password.RequiredLength = 4;
})
.AddRoles<IdentityRole>()
.AddEntityFrameworkStores<ApplicationDbContext>();
```

Attributes can also be used to signify that a requirement must be fulfilled in
order to run this code:
```cs
[Authorize]
// your action
// aka this action required the user to be authenticated

[AllowAnonymous]
// this action allows anonymous access
```

#subsubsection("This.User")
This.User contains the currently logged in user, of which the type is "ClaimsPrincipal"
- ClaimsPrincipal
  - per dependency injection, instance of UserManager\<ApplicationUser\>
  - UserManager allows for CRUD operations for the application users
    - var user= await \_userManager.GetUserAsync(User);
    - var id = \_userManager.GetUserId(User);

#subsubsubsection("Claims")
These claims are essentially just data about a user in a key value store:
```cs
User.FindFirstValue(ClaimTypes.NameIdentifier); //=> "9e83e774-ba92-43eb-89bf-8f82df18096b"
User.FindFirstValue(ClaimTypes.Name); //=> michael.gfeller@ost.ch
User.FindFirstValue(ClaimTypes.Email); //=> null
```
#align(
  center, [#image("../../Screenshots/2023_12_27_02_45_47.png", width: 100%)],
)

#subsubsection("Usage")
Automatic:
```cs
// authorization can only be done when already authenticated
[Authorize]
public ActionResult Create()
{
  return View(new Order() { Name = "Hawaii" });
}
```
Manually:
```cs
public ActionResult Create() {
  if (User.Identity.IsAuthenticated) {
    return View(new Order() { Name = "Hawaii" });
  }
  else {
    return new StatusCodeResult(401);
  }
}
```

#subsection("Authorization")
There are 3 main mechanism to guarantee authorization:
- Attributes
  - [Authorize(Roles = "Admin,PowerUser")]
  - [Authorize(Policy = "OlderThan18,Founders")]
- Services
  - var user = await \_userManager.GetUserAsync(User);
  - var isInRole = await \_userManager.IsInRoleAsync(user, "Admin");
  - var result = await \_authorizationService.AuthorizeAsync(User, null, "Founders");
- Claims
  - User.HasClaim(ClaimTypes.Role, "Admin")

#subsubsection("Example with Razor")
```asp
@inject UserManager<ApplicationUser> manager;
@inject ApplicationDbContext context;
@{
var user = await manager.GetUserAsync(User);
if (user != null && await manager.IsInRoleAsync(user, "Administrator")){
<h1>Alle Bestellungen</h1>
<table class="table">
<thead>
<tr>
<th>#</th>
</tr>
</thead>
<tbody>
@foreach (var x in context.Orders.Include(x => x.Customer)) {
<tr><td><a asp-action="Show" asp-controller="Order" asp-route-Id="@x.Id">@x.Id</a></td></tr>
}
</tbody>
</table>
}
}
```

#subsubsection("JWT Token")
- JSON tokens
- should only be used with https
- default way to handle authentication and authorization
#align(
  center, [#image("../../Screenshots/2023_12_27_02_50_36.png", width: 100%)],
)

#subsection("Integration Tests")
Integration tests allow you to create a mock page that can be accessed outside the actual network.
This is especially useful to test scenarios like, "is every page protected with authentication and authorization?"

```cs
// setup test environment
var factory = new WebApplicationFactory<Startup>();
// client that will send the test requests
Client = factory.CreateClient();
// server that will handle the clients requests
Server = factory.Server;
```

```cs
// code for the factory
public class CustomWebApplicationFactory : WebApplicationFactory<Startup>
{
private readonly string _dbId = Guid.NewGuid().ToString();
protected override void ConfigureWebHost(IWebHostBuilder builder)
{
builder.ConfigureServices(services =>
{
services.AddDbContext<ApplicationDbContext>(options =>
// in the test environment we want to use the in memory database
options.UseInMemoryDatabase(_dbId));
});
builder.UseEnvironment("TEST");
builder.ConfigureServices(x => x.AddMvc()
// ignore antiforgery for tests
.AddRazorPagesOptions(o => o.Conventions.ConfigureFilter(new IgnoreAntiforgeryTokenAttribute())));
builder.UseStartup<Startup>();
base.ConfigureWebHost(builder);
}
protected override IWebHostBuilder CreateWebHostBuilder()
{
return WebHost.CreateDefaultBuilder();
}
}
```

```cs
// example for a test
[Fact]
public async Task CreateOrder()
{
var wrongOrder = JsonConvert.SerializeObject(new NewOrderViewModel() {Name = "X"});
var okOrder = JsonConvert.SerializeObject(new NewOrderViewModel() {Name = "Hawaii"});
var result = await _sut.Request("/api/orders", null, HttpMethod.Post, new StringContent(wrongOrder, …));
Assert.Equal(HttpStatusCode.Unauthorized, result.StatusCode);
// …
Assert.Equal(1, _sut.Server.Host.Services.GetService<ApplicationDbContext>().Order.Count());
}
```

#subsubsection("Pitfalls")
- *The same in memory database is used over all tests* -> either make sure the change doesn't matter, or use a different one for each test
- .AddApplicationPart(typeof(Startup).Assembly);\
  just do it when testing....
