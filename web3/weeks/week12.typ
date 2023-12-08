#import "../../utils.typ": *

#section("ASP NET")
- .not framework
- server side rendering -> expressjs, go server stuff, ruby on rails

#subsection("C worse")

#subsubsection("HTML Tags")
Csharp obviously doesn't know about HTML tags or its properties, this can be
fixed with ASP.NET tags:

```cs
[Required]
[StringLength(100, MinimumLength = 10)]
public string Name { get; set; }

[HttpPost]
public ActionResult About()

public static void Main(string[] args) {
  // ASP specific Tag query
  var typesWithAttribute = (
    from type in Assembly.GetEntryAssembly().GetTypes()
    where type.GetCustomAttribute<SomeAttribute>() != null
    select type
  ).ToList();

  // create instance of this type
  PrintObj(Activator.CreateInstance(typesWithAttribute.First()));
  Console.ReadLine();
}
```

#subsubsection("Anonymous types")
```cs
// no name
var v = new { Amount = 108, Message = "Hello" };
Console.WriteLine(v.Amount + v.Message);
```

#subsubsection("Class extensions")
```cs
string s = "Hello Extension Methods";
int i = s.WordCount();
// this exists already
public static class MyExtensions {
  // new function added to parameter
  // e.g. this -> string
  // hence on the type of variable str, we will add a new function
  public static int WordCount(this string str) {
    return str.Split(new char[] { ' ', '.', '?' }).Length;
  }
}
// note, you can't access private variables from the class here!
```

These tags can also be read with *reflection*.

#subsection("Convention")
ASP does not do much configurability
- uses typical conventions instead
- idea is to not need to think about how to setup things
  - framework does this instead
- on certain actions, ASP will automatically create a success or failure URL -> no
  need to define it your own
  - pain when this is not what you want/need
- For users who aren't familiar with all convention rules, behavior might seem
  random.

#subsection("Thread Pool")
- ASP.NET provides its own thread pool
  - size is configurable
- ASP chooses a thread for each request
  - this thread is blocked until request processing is done
  - premature return possible
- NOTE: don't create static data for controller and services
  - ASP creates a new controller for each request -> aka won't work!
  - if you want static data, you need to provide custom datastructure that is thread
    safe!

#subsection("MVVM (Model-View-Viewmodel) in ASP")
#align(
  center,
  [#image("../../Screenshots/2023_12_08_06_11_45.png", width: 70%)],
)

#subsection("Middlewares")
- each middleware can end the request or pass it to the next one
- example middlewares:
  - logging
  - mvc
  - authorization
  - error handling
#align(
  center,
  [#image("../../Screenshots/2023_12_08_06_13_17.png", width: 60%)],
)

#subsection("Example Application")
Setup Code\
```cs
var builder = WebApplication.CreateBuilder(args);

// Dependency Injection
builder.Services.AddSingleton<TodoService, TodoService>();

var app = builder.Build();

// Register Middleware
app.Use(async (context, next) => { /* … */ });

app.Run();
``` Configuration ```json
"https": {
 "commandName": "Project",
 "dotnetRunMessages": true,
 "launchBrowser": true,
 "applicationUrl": "https://localhost:7250",
 "environmentVariables": {
 "ASPNETCORE_ENVIRONMENT": "Development"
 }
},
```

Register New Middlewares on entire application

```cs
app.Use(async (context, next) => {
  System.Diagnostics.Debug.WriteLine("Handling request");
  await next.Invoke();
  System.Diagnostics.Debug.WriteLine("Finished handling request.");
});
```

Register middleware on an existing path and fork into middleware

```cs
app.Map("/logging", builder => {
 // builder creates fork
 // middleware executed inside fork
 builder.Run(async (context) => {
 await context.Response.WriteAsync("Hello World!");
 });
});
```

Register End middleware

```cs
// this middleware ends the request -> no next called, and no fork called
app.Run(async (context) => {
 await context.Response.WriteAsync("Hello World!");
});
```

Register Middleware as generic class parameter

```cs
app.UseMiddleware<RequestLoggerMiddleware>();

public class RequestLoggerMiddleware {
  private readonly RequestDelegate _next;
  private readonly ILogger _logger;

  // next variable is the next middleware
  // further parameters are handled by the dependency container -> injection
  public RequestLoggerMiddleware(RequestDelegate next, ILoggerFactory loggerFactory) {
    _next = next;
      _logger = loggerFactory.CreateLogger<RequestLoggerMiddleware>();
  }

  public async Task Invoke(HttpContext context) {
    _logger.LogInformation("Handling request: " + context.Request.Path);
    await _next.Invoke(context);
    _logger.LogInformation("Finished handling request.");
  }
}
```

#subsection("Dependency Injection")
- Idea
  - define interfaces that must be implemented
  - a resolver searches for a class inside the container that fits these interfaces
  - if no class is found, throw error
- differences between dependency injection containers
  - different default behavior
  - registration can me manual or automatic
  - some resolvers throw exceptions when the result isn't clear

#subsubsection("Example")
```cs
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IUserService, UserService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseMiddleware<UserMiddleware>();

app.Run();

// use the injection
public class UserMiddleware {
  private readonly RequestDelegate _next;

  // so called captive dependency
  public UserMiddleware(RequestDelegate next, IUserService userService) {
    // problem is that the requestdelegate variable would not live as long as the class variable
    // Hence we keep the service alive for longer by keeping the reference, however this does not mean the service is still active!
    _next = next;
  }
  public async Task Invoke(HttpContext context, IUserService userService) {
    // no captive dependency -> e.g. no references set
    await context.Response.WriteAsync(string.Join(", ", userService.Users));
  }
}
```

Lifetimes:
- Transient: temporary -> function(new Someting()) -> Something is transient, e.g.
  best for small, stateless services that are created each time
  - created once per usage
- Scoped: local variable with a regular scope
  - created once per request
- Singleton: creation can be lazy, after that: as long as the app runs
  - created once per app

#text(
  red,
)[Important:
  - DBContext is not multi threading safe!
  - Only use services in combination with same level services or longer living
    services
]

#align(
  center,
  [#image("../../Screenshots/2023_12_08_06_40_23.png", width: 100%)],
)
- T: transient service
- S: singleton service
A singleton may NOT use a transient service -> transient lives shorter\
A transient may use a singleton service -> singleton lives longer

#subsection("Project Structure")
- templates with different features
- wwwroot
  - everything needed for a website
- appsettings.json
  - settings for website and connection for db
- Program.cs
  - entry point for program
  - middleware and dependency injection configuration

#subsection("Pages")
Pages in ASP are created using a special templating engine -> htmx similar
```asp
<!-- With the @ you can use Csharp code inside the template! -->
<!-- Single statement blocks -->
@{ var total = 7; }
@{ var myMessage = "Hello World"; }
<!-- Inline expressions -->
<p>The value of your account is: @total </p>
<p>The value of myMessage is: @myMessage</p>
<!-- Multi-statement block -->
@{
var greeting = "Welcome to our site!";
var weekDay = DateTime.Now.DayOfWeek;
var greetingMessage = greeting + " Today is: " + weekDay;
<!-- Note, you can also just use html here again! Compiler will know it's html
-->
}
<p>The greeting is: @greetingMessage</p>
```

- Good for web applications with "page" focus
  - no router needs to be defined
  - best practices for server side rendering
- can be combined with MVC
  - provides static pages
  - REST-API with mvc
#align(
  center,
  [#image("../../Screenshots/2023_12_08_07_17_32.png", width: 100%)],
)

#subsubsection("Page composition")
Pages have 2 files, the Csharp code and the view code: ```cs
// Csharp
public class HelloWorldModel : PageModel {
 public string HelloWorld { get; set; }
 public void OnGet() {
 HelloWorld = "Hi World!";
 }
}
```

```asp
@page
@model HelloWorldModel
@{
  ViewData["Title"] = "HelloWorld";
}
<h1>@Model.HelloWorld</h1>
```
\@Model -> this will bind the following variable to Model\
E.g. you can use the variable HelloWorld inside the HelloWorldModel class with
\@Mode.HelloWorld

#subsubsection("OnPost/OnGet")
```cs
public void OnPost(string echoText, long times) {
  EchoText = echoText;
  Times = times;
}
public void OnPost(EchoModel data) {
  Data = data;
}
```

#subsubsection("Bind Property")
With bind property, you can ommit the onPost and instead use the data on the
class immediately:

```cs
// like ngModel in Angular
// or useState in React
public class PostModel : PageModel {
 [BindProperty]
 public string EchoText { get; set; }
 [BindProperty]
 public long Times { get; set; }
}
```

#subsubsection("@Page")
```cs
public class RoutingModel : PageModel {
  public int Id { get; set; }
  [BindProperty(SupportsGet = true, Name = "Id")]
  public int Id2 { get; set; }
  public void OnGet(int id) {
   Id = id;
  }
}
```
```asp
@page "/test/{id:int?}"
@model Examples.Pages.Page.RoutingModel
@{
ViewData["Title"] = "Routing";
}
<h1>Routing</h1>
@RouteData.Values["id"]
```
With the page directive, you can also define a custom URL alongside possible
parameters like above.

#subsection("Razor")
#subsubsection("_layout.cshtml")
includes the structure of the website \@RenderBody()\
The place where all the content page will be rendered:\
```asp
<div class="container">
  @RenderBody()
</div>
```
\@RenderSection()\
defines the section, in which the content page can place its content\
```asp
<div class="container">
  <a class="navbar-brand" asp-area="" asp-page="/Index">Home</a>
  @RenderSection("Nav", false)
</div>

@section Nav{
  <a class="navbar-brand" asp-area="" asp-page="./ViewData">ViewData</a>
  <a class="navbar-brand" asp-area="" asp-page="./TempData">TempData</a>
}
```

#subsubsection("_ViewStart.cshtml")
- hierarchical
- includes code which will be run before the razor-files
- defines the layout for all pages
```asp
@{
  Layout = "_Layout";
}
```

#subsection("AJAX")
- Handler functions should have the following naming scheme: On[Method][Name]
- these can be used via: [Method]/[Page]?handler=[HandlerName]
```cs
public class AjaxModel : PageModel {
  public IActionResult OnPostEcho(string echoText) {
    return this.Content(echoText);
  }
  public IActionResult OnGetAutocomplete(string text) {
    return new JsonResult(_citiesService.GetCities(text));
  }
}
```
Example use:
- POST /Ajax?handler=echo\
- GET /Ajax?handler=autocomplete\

#subsubsection("Return Types")
Return values of the functions with IActionResult can be the following:
- ContentResult
  - StringResult
  - JsonResult
  - EmptyResult
- Status
  - NotFoundResult
  - StatusCodeResult
- Redirects
  - RedirectToPage
  - RedirectToPagePermanent
- Hilfsmethoden
  - Page() und Partial()
  - Content()
  - ViewComponent()

#subsubsection("Bigger example")
```cs
// Ajax.cshtml.cs
  public IActionResult OnPostEcho(string echoText){
  return this.Content(echoText);
}
```
AjaxFetch.cshtml: ```asp
<form asp-page="Ajax" asp-page-handler="Echo" id="echoForm">
 <input name="echoText"/>
 <input type="submit"/>
</form>
<div id="echoOutput"></div>
@section Scripts{
<script>
 const echo = document.getElementById("echoOutput");
 document.getElementById("echoForm").addEventListener("submit",
 async (args) => {
 args.preventDefault();
 const formData = new FormData(args.target);
 const result = await fetch(args.target.action, { method: "post", body: formData
});
 echo.innerText = await result.text();
 });
</script>
}
```

#subsubsection("Form without javascript")
```asp
<form asp-page="Ajax" asp-page-handler="Echo" id="echoForm" data-ajax="true"
  data-ajax-method="POST" data-ajax-mode="replace" data-ajax-update="#echoOutput">
  <input name="echoText"/>
  <input type="submit"/>
</form>
<div id="echoOutput"></div>
@section Scripts{
  <script
  src="https://cdn.jsdelivr.net/npm/jquery-ajax-
  unobtrusive@3.2.6/dist/jquery.unobtrusive-ajax.min.js"
  integrity="sha256-PAC000yuHt78nszJ2RO0OiDMu/uLzPLRlYTk8J3AO10="
  crossorigin="anonymous"></script>
}
```
#align(
  center,
  [#image("../../Screenshots/2023_12_08_07_40_44.png", width: 50%)],
)

#subsection("Data")

#subsubsection("EF Entity Framework (OR Mapper)")

#align(
  center,
  [#image("../../Screenshots/2023_12_08_07_59_02.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_12_08_07_53_36.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_12_08_07_53_50.png", width: 100%)],
)

#subsubsubsection("Providers")
- Microsoft.EntityFrameworkCore.SqlServer
- Microsoft.EntityFrameworkCore.SQLite
- Microsoft.EntityFrameworkCore.InMemory
  - no migration
  - for testing

#subsubsubsection("Entity")
```cs
public class Order {
  public long Id { get; set; }
  [Required]
  public string Name { get; set; }
  public DateTime Date { get; set; }
  public OrderState State { get; set; }
  public virtual ApplicationUser Customer { get; set; }
  [Required]
  public string CustomerId { get; set; }
  public Order() {
    Date = DateTime.Now;
  }
}
```

#subsubsubsection("Conventions")
- public [long/string] Id {get;set;}
  - recgonized as the primary key of the entity
- public virtual ApplicationUser Customer { get; set; }
  - recognized as navigation property
- public [long/string] CustomerId { get; set; }
  - recognized as the foreign key for the customer entity

#subsubsubsection("Important Attributes")
- [Required]
  - constraint for the database -> NOTNULL
  - also possible for navigation properties
  - used for the differentiation between aggregation and association
- [NotMapped]
  - not used in DB
- [Key]
  - defines the primary key for the entity
- [MaxLength(10)]
  - influences the allocation size of the property

#subsubsubsection("Migration")
Migration can't be done automatically(fully):
- dotnet ef migrations –help
- dotnet ef migrations add Init 
  - requires function in code, see below
- dotnet ef migrations script
- dotnet ef database update 
  - this can be automated

```cs
public partial class Init : Migration {
  protected override void Up(MigrationBuilder migrationBuilder) {
      migrationBuilder.CreateTable(
      name: "Orders",
      columns: table => new {
        Id = table.Column<long>(nullable: false)
        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
        Date = table.Column<DateTime>(nullable: false),
        Name = table.Column<string>(nullable: true),
        State = table.Column<int>(nullable: false)
      },
      constraints: table => {
        table.PrimaryKey("PK_Orders", x => x.Id);
    });
  }
  protected override void Down(MigrationBuilder migrationBuilder) {
    migrationBuilder.DropTable(name: "Orders");
  }
}
```

You can migrate with 3 different options:
- dotnet ef database update
- execute script
- migrate in code\
  ```cs
  app.ApplicationServices.GetRequiredService<ApplicationDbContext>().Database.Migrate();
  ```

