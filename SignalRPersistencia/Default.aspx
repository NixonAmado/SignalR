<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SignalRPersistencia._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container w-100 m-auto">    
        <label for="userName">UserName: </label>
        <input type="text" id="userName"/>
        <input type="button" id="login" value="Log in"/>

    </div>
    
    <div class="row">
        <div class="col-8">
        <div class="col-12 border-bottom">
            <h3 class="text-center"> Private chat </h3>
            <label for="toUserName">Send to:</label>
            <input type="text" id="toUserName" placeholder="destination user name" />
            <input type="text" id="toMessage" placeholder="message" />
            <input type="button" id="sendPrivateMessage" value="send"/>

            <ul id="privateChat">

            </ul>
            </div>
            <br />
            <div class="col-12 border-bottom">
                <h3 class="text-center"> Broadcast chat </h3>
                <input type="text" id="broadcastMsg" placeholder="message" />
                <input type="button" id="sendBroadcastMsg" value="send"/>

                <ul id="broadcastChat">

                </ul>

            </div>
            <br />

        <div class="col-12">
            <label for="groupName">Create group:</label>
            <input type="text" id="groupName"/>
            <input type="button" id="CreateGroup" value="Create"/>
            <ul id="groups">

            </ul>
            <br />
            <label for="GroupToJoin">Join Group</label>
            <input type="text" id="GroupToJoin" />
            <input type="button" id="joinGroup" value="Join Group" />
            <h3>
                Group Conversation
            </h3>
            <input id="IptGroupConversation"/>
            <ul id="GroupConversation">

            </ul>
            <input type="button" id="leaveGroup" value="Leave Group" />

        </div>
        </div>
        <div class="col-4">
            <h2 class="bg-dark text-light">Connections</h2>
            <h3 class="fs-3">Users</h3>
            <ul id="usersConnected">

            </ul>
            <h3 class="fs-3">Groups</h3>
            <ul id="groupsCreated">

            </ul>

        </div>

    </div>

    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script src="Scripts/jquery.signalR-2.4.3.min.js"></script>
    <script src="signalr/hubs"></script>

    <script type="text/javascript">
        var userList = ""
        $(function () {
            var chat = $.connection.chatHub;
            console.log(chat);

            chat.client.receiveMessage = function (userName, message) {
                $('#messages').append('<li><strong>' + userName + '</strong>: ' + message + '</li>');
            };

            chat.client.ReceivePrivateMessage = function (fromUserName, message) {
                $('#privateChat').append('<li><strong>' + fromUserName + '</strong>: ' + message + '</li>')
            }

            chat.client.BroadcastChat = function (fromUserName, message) {
                $('#broadcastChat').append('<li><strong>' + fromUserName + '</strong>: ' + message + '</li>')
            }
            chat.client.UpdateLists = function (list, listType) {
                if (listType === 1) {
                    $('#usersConnected').empty();
                }
                else if (listType === 2) {
                    $('#groupsCreated').empty();
                }
                $.each(list, function (index, gValue) {
                    if (listType === 1) {
                        $('#usersConnected').append('<li><strong>' + gValue + '</li>');
                    } else if (listType === 2) {
                        $('#groupsCreated').append('<li><strong>' + gValue + '</li>');
                    }
                });
            };



            $.connection.hub.start().done(function () {
                $('#login').click(function () {
                    var userName = $('#userName').val();
                    chat.server.registerUser(userName);
                });

                $('#sendPrivateMessage').click(function () {
                    var message = $('#toMessage').val();
                    var toUserName = $('#toUserName').val();
                    var userName = $('#userName').val();
                    console.log(userName);
                    chat.server.sendMessageToUser(toUserName, userName, message);
                });

                $('#sendBroadcastMsg').click(function () {
                    var message = $('#broadcastMsg').val();
                    var userName = $('#userName').val();
                    console.log(userName);
                    chat.server.sendBroadcastMessage(userName, message);
                });

                // #region GROUPS

                $('#CreateGroup').click(function () {
                    var groupName = $('#groupName').val();
                    chat.server.createGroup(groupName);
                });

                $('#sendToGroup').click(function () {
                    var groupName = $('#groupName').val();
                    var userName = $('#userName').val();
                    var message = $('#message').val();
                    chat.server.sendMessageToGroup(groupName, userName, message);
                });

                $('#joinGroup').click(function () {
                    var groupName = $('#groupName').val();
                    chat.server.joinGroup(groupName);
                });

                $('#leaveGroup').click(function () {
                    var groupName = $('#groupName').val();
                    chat.server.leaveGroup(groupName);
                });
            });
        });
    </script>
</asp:Content>
