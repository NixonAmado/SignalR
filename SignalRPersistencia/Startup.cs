using Microsoft.Owin;
using Owin;
using Microsoft.AspNet.SignalR;

[assembly: OwinStartup(typeof(SignalRPersistencia.Startup))]
namespace SignalRPersistencia
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            //string sqlConnectionString = "Server=(localdb)\\ChatDB;Database=ChatDb;Integrated Security=true;";
            //GlobalHost.DependencyResolver.UseSqlServer(sqlConnectionString);

            app.MapSignalR();
        }
    }
}