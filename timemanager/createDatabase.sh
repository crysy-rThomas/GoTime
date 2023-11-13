#!/bin/bash

# create roles table
mix phx.gen.json Roles Role roles title:string
mix ecto.migrate

# create users table
mix phx.gen.json Users User users firstname:string lastname:string role:references:roles email:string password:string
mix ecto.migrate

# create clocks table
mix phx.gen.json Clocks Clock clocks status:boolean user:references:users time:datetime description:string
mix ecto.migrate

# create workingtimes table
mix phx.gen.json Workingtimes Workingtime workingtimes user:references:users start_time:datetime end_time:datetime
mix ecto.migrate

# create tokens table
mix phx.gen.json Tokens Token tokens user:references:users token:string
mix ecto.migrate