using System;
using System.Collections.Generic;
using System.Linq;

public class ChatRepository
{
    private readonly ChatContext _dbContext;

    public ChatRepository()
    {
        _dbContext = new ChatContext();
    }

    public void AddMessage(ChatMessage message)
    {
        try
        {
            _dbContext.ChatMessages.Add(message);
            _dbContext.SaveChanges();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error al agregar mensaje a la base de datos: " + ex.Message);
        }

    }
    public List<ChatMessage> GetRecentMessages(int count)
    {
        return _dbContext.ChatMessages
            .OrderByDescending(m => m.Timestamp)
            .Take(count)
            .ToList();
    }
}
