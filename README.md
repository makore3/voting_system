# Voting System 🗳️

**Voting System** is a smart contract module written in **Move (Sui blockchain)**.  

It allows the creation and management of public elections, with functionalities for proposals, voting, updating, and closing elections.

---

## Features ✨

- Create new elections with a proposal.  
- Add, update, and remove votes.  
- Prevent duplicate voting.  
- Close elections to stop further votes.  
- Delete elections (only by the creator).  
- Error handling with custom codes.  

---

## Project Structure 📂

```plaintext
├── sources/
│   └── voting_system.move   # Main module with structs, errors, and functions
├── Move.toml                # Project configuration file
└── README.md                # Project documentation
```

## Module Overview 📘

### Structs
- **Election** → Stores all the information of an election, including:
  - `id` → unique identifier (UID).  
  - `proposal` → description or title of the election.  
  - `votes` → mapping of voters and their vote details (`VecMap<address, VoterInfo>`).  
  - `status` → indicates if the election is open (`true`) or closed (`false`).  
  - `creator` → address of the account that created the election.  

- **VoterInfo** → Stores data for each voter:
  - `vote` → the vote option chosen (numeric `u8`).  
  - `has_voted` → flag indicating whether the user has already voted.  

---

### Errors
- **E_ALREADY_VOTED (0)** → The voter has already cast a vote.  
- **E_VOTE_NOT_FOUND (1)** → No vote was found for the user.  
- **E_ELECTION_CLOSED (2)** → The election is already closed and cannot be modified.  
- **E_NOT_AUTHORIZED (3)** → The user is not authorized to perform this action.  

---

### Main Functions
- **`create_election(proposal: String, ctx: &mut TxContext)`**  
  Creates a new election with the given proposal. The creator becomes the owner of the election.  

- **`add_vote(election: &mut Election, vote: u8, ctx: &mut TxContext)`**  
  Casts a vote for the current user, preventing duplicates.  

- **`update_vote(election: &mut Election, vote: u8, ctx: &mut TxContext)`**  
  Updates the vote of the current user if they already voted.  

- **`remove_vote(election: &mut Election, ctx: &mut TxContext)`**  
  Removes the vote of the current user from the election.  

- **`close_election(election: &mut Election, ctx: &mut TxContext)`**  
  Closes the election (only the creator can perform this action).  

- **`delete_election(election: Election, ctx: &mut TxContext)`**  
  Permanently deletes an election (only the creator can perform this action).  

## Technologies 🛠️

- **Move Language** 🦀 – smart contract programming  
- **Sui Blockchain** 🌐 – execution environment  
- **Sui CLI** 💻 – building, testing, and publishing modules  

## Contributions 🤝  

Contributions are welcome!  

Fork this repository, create a new branch, make your changes, and open a *pull request*.  

## License  

[MIT](https://choosealicense.com/licenses/mit/)  
