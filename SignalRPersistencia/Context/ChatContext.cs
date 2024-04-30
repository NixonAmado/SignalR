using System.Data.Entity;

public class ChatContext : DbContext
{
    public ChatContext() : base("name=DefaultConnection")
    {
    }

    // Define DbSet para tus modelos aquí
    public DbSet<ChatMessage> ChatMessages { get; set; }
}