module voting_system::voting_system {
    use sui::vec_map::{VecMap, Self};
    use std::string::String;

    // ===========================
    // Structs
    // ===========================

    /// Represents a public election with a proposal, votes, and creator.
    public struct Election has key, store {
        id: UID,
        proposal: String,
        votes: VecMap<address, VoterInfo>,
        status: bool,
        creator: address,
    }

    /// Stores information about a voter and their vote.
    public struct VoterInfo has store, drop {
        vote: u8,
        has_voted: bool,
    }
    // ===========================
    // Errors
    // ===========================

    /// Raised when a voter tries to vote more than once.
    const E_ALREADY_VOTED: u64 = 0;
    /// Raised when trying to update/remove a non-existent vote.    
    const E_VOTE_NOT_FOUND: u64 = 1;
    /// Raised when attempting to vote or update after election is closed.
    const E_ELECTION_CLOSED: u64 = 2;
    /// Raised when a non-creator tries to perform restricted actions.
    const E_NOT_AUTHORIZED: u64 = 3;

    // ===========================
    // Functions
    // ===========================

    /// Creates a new election with the given proposal.
    /// The caller becomes the creator and election remains open.
    #[allow(lint(self_transfer))]
    public fun create_election(proposal: String, ctx: &mut TxContext) {
        let election = Election {
            id: object::new(ctx),
            proposal,
            votes: vec_map::empty(),
            status: true,
            creator: tx_context::sender(ctx),
        };
        transfer::transfer(election, tx_context::sender(ctx));
    }

    /// Adds a new vote for the caller.
    /// Fails if the caller has already voted or if the election is closed.
    public fun add_vote(election: &mut Election, vote: u8, ctx: &mut TxContext) {
        assert!(election.status, E_ELECTION_CLOSED);
        
        let voter_info = VoterInfo {vote, has_voted: true};
        let wallet = tx_context::sender(ctx);
        assert!(!election.votes.contains(&wallet), E_ALREADY_VOTED);

        election.votes.insert(wallet, voter_info);
    }

    /// Updates the caller's existing vote.
    /// Fails if no vote exists or if the election is closed.
    public fun update_vote(election: &mut Election, vote: u8, ctx: &mut TxContext) {
        assert!(election.status, E_ELECTION_CLOSED);

        let wallet = tx_context::sender(ctx);
        assert!(election.votes.contains(&wallet), E_VOTE_NOT_FOUND);

        let actual_vote = &mut election.votes.get_mut(&wallet).vote;
        *actual_vote = vote;
    }

    /// Removes the caller's vote from the election.
    /// Fails if no vote exists or if the election is closed.
    public fun remove_vote(election: &mut Election, ctx: &mut TxContext) {
        assert!(election.status, E_ELECTION_CLOSED);

        let wallet = tx_context::sender(ctx);
        assert!(election.votes.contains(&wallet), E_VOTE_NOT_FOUND);

        election.votes.remove(&wallet);
    }

    /// Deletes an election permanently.
    /// Can only be performed by the election creator.
    public fun delete_election(election: Election, ctx: &mut TxContext) {
        assert!(election.creator == tx_context::sender(ctx), E_NOT_AUTHORIZED);

        let Election {id, proposal: _, votes: _, status: _, creator:_} = election;
        id.delete();
    }

    /// Closes an election, preventing further voting or updates.
    /// Can only be performed by the election creator.
    public fun close_election(election: &mut Election, ctx: &mut TxContext) {
        assert!(election.creator == tx_context::sender(ctx), E_NOT_AUTHORIZED);
        election.status = false;
    }
}