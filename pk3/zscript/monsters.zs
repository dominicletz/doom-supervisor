class AllMonstersHandler : EventHandler
{
    array<Actor> g_allMonsters;

    static void RegisterMonster(Actor monster)
    {
        let allMonstersHandler = AllMonstersHandler(EventHandler.Find("AllMonstersHandler"));

        if (allMonstersHandler)
        {
            allMonstersHandler.g_allMonsters.Push(monster);
            console.printf("AllMonstersHandler has %d monsters", allMonstersHandler.g_allMonsters.Size());
        }
    }

    static Actor KillMonsterByPid(string pid)
    {
        let allMonstersHandler = AllMonstersHandler(EventHandler.Find("AllMonstersHandler"));

        Actor monsterToKill = null;

        if (allMonstersHandler)
        {
            for (int i = 0; i < allMonstersHandler.g_allMonsters.Size(); i++)
            {
                monsterToKill = allMonstersHandler.g_allMonsters[i];
                // Double-check the pointer isn't null
                if (monsterToKill && monsterToKill.GetTag() == pid && monsterToKill.Health >= 1)
                {

                    console.printf("Killing %s with %s ...", monsterToKill.GetClassName(), monsterToKill.GetTag());
                    monsterToKill.A_Die();
                    break;
                }
            }
        }

        return monsterToKill;
    }
}

class Helper : Actor
{
    static Actor SpawnWithPid(string monsterToSpawn, string pid, vector3 position, uint flags)
    {
        let monster = Actor.Spawn(monsterToSpawn, position, flags);
        monster.SetTag(pid);

        console.printf("Tagged new %s as '%s'", monsterToSpawn, monster.GetTag());

        Helper.PushElixirMessage(monsterToSpawn, pid, "spawned", position);

        AllMonstersHandler.RegisterMonster(monster);

        return monster;
    }

    static void GetPlayerPos()
    {
        let player = Helper.GetPlayer();

        PushElixirMessage("Player", "Supervisor", "getPos", player.Pos);
    }

    static Actor GetPlayer()
    {
        return players[0].mo;
    }

    static vector3 RandomPositionAroundPlayer(int range)
    {
        vector3 playerPosition = Helper.GetPlayer().Pos;
        vector3 position;
        // position.X = playerPosition.X + FRandom(range, -range);
        // position.Y = playerPosition.Y + FRandom(range, -range);
        // position.Z = playerPosition.Z;
        position.X = 2088 + FRandom(range, -range);
        position.Y = -3461 + FRandom(range, -range);
        position.Z = -52;
        return position;
    }

    static vector3 PositionFromElixir(string elixirPosition)
    {
        // elixirPosition has format "(x,y,z)"
        string toSplit = elixirPosition.Mid(1, elixirPosition.Length() - 2);
        Array<String> stringCoordinates;
        toSplit.Split(stringCoordinates, ",");
        let x = stringCoordinates[0].ToInt();
        let y = stringCoordinates[1].ToInt();
        let z = stringCoordinates[2].ToInt();

        vector3 toReturn;
        toReturn.X = x;
        toReturn.Y = y;
        toReturn.Z = z;

        let range = 200;
        toReturn.X = 2088 + FRandom(range, -range);
        toReturn.Y = -3461 + FRandom(range, -range);
        toReturn.Z = -52;


        return toReturn;
    }

    static void PushElixirMessage(string className, string pid, string event, vector3 position)
    {
        console.printf("**ELIXIR** %s %s %s at (%d, %d, %d)", pid, className, event, position.X, position.Y, position.Z);
    }
}
