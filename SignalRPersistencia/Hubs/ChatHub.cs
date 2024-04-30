using System;
//using System.Threading.Tasks;
//using Microsoft.AspNet.SignalR;

//public class ChatHub : Hub
//{
//    private readonly ChatRepository _repository;

//   public ChatHub()
//    {
//        _repository = new ChatRepository();
//    }

//    public async Task Send(string sender, string content)
//    {
//        var message = new ChatMessage { Content = content, Sender = sender, Timestamp = DateTime.Now };
//        _repository.AddMessage(message);
//        await Clients.All.SendAsync(message);
//    }
//}

using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Ajax.Utilities;
using System.Collections;

public class ChatHub : Hub
{
    private static Dictionary<string, string> _userNames = new Dictionary<string, string>();
    private static Dictionary<int, string> _groups = new Dictionary<int, string>();

    public void RegisterUser(string username)
    {
        _userNames[Context.ConnectionId] = username;
              SendListUpdate(_userNames, 1);
    }
    public  void SendMessageToUser(string toUserName, string fromUserName, string message)
    {
        // Encuentra el ConnectionId asociado al ID de usuario
        var connectionId = _userNames.FirstOrDefault(x => x.Value.ToLower() == toUserName.ToLower()).Key;

        if (connectionId != null)
        {
            // Envía a mi mismo
            Clients.Caller.ReceivePrivateMessage(fromUserName, message);
            // Envía el mensaje al usuario específico
            Clients.Client(connectionId).ReceivePrivateMessage(fromUserName, message); ;
        }
    }

    public void SendBroadcastMessage(string fromUserName, string message)
    {
        Clients.All.BroadcastChat(fromUserName, message);
    }


    public void SendMessageToGroup(string groupName, string fromUserName, string message)
    {
        Clients.Group(groupName).SendAsync("ReceiveMessage", fromUserName, message);
    }

    public void CreateGroup(string groupName)
    {
        var group = _groups.FirstOrDefault(x => x.Value.ToLower() == groupName).Value;
        if (group == null)
        {
            _groups.Add(_groups.Count + 1, groupName);
        }
        Groups.Add(Context.ConnectionId, groupName);
        SendListUpdate(_groups, 2);


    }

    public void LeaveGroup(string groupName)
    {
        Groups.Remove(Context.ConnectionId, groupName);
    }

    public override Task OnConnected()
    {
        SendListUpdate(_userNames,1);
        SendListUpdate(_groups,2);

        return base.OnConnected();
    }

    private void SendListUpdate<T>(Dictionary< T ,string> _updateList,int listType)
    {
        // Obtener la lista de nombres de usuario
        var list = _updateList.Values.ToList();

        // Enviar la lista de usuarios conectados a todos los clientes
            Clients.All.UpdateLists(_updateList, listType);
    }
}
