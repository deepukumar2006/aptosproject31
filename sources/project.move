module MyModule::TaskAutomation {

    use aptos_framework::coin;
    use aptos_framework::signer;
    use aptos_framework::aptos_coin::{AptosCoin};

    struct Task has store, key {
        creator: address,
        reward: u64,
        is_completed: bool,
    }

    // Function for posting a task with a reward
    public fun post_task(creator: &signer, reward: u64) {
        let task = Task {
            creator: signer::address_of(creator),
            reward,
            is_completed: false,
        };
        move_to(creator, task);
    }

    // Function to verify task completion and distribute reward
    public fun complete_task(creator: &signer, worker: address) acquires Task {
        let task = borrow_global_mut<Task>(signer::address_of(creator));

        // Ensure the task is not already completed
        assert!(!task.is_completed, 1);

        // Mark task as completed
        task.is_completed = true;

        // Transfer the reward to the worker
        coin::transfer<AptosCoin>(creator, worker, task.reward);
    }
}
