import from byllm.llm { Model }
import from dotenv { load_dotenv as ld }
import os;

def load_and_cache_api_key(){
    # Load variables from .env into the environment
    ld();
    # Retrieve the key
    api_key = os.getenv("GEMINI_API_KEY");
    if not api_key{
        raise ValueError("GEMINI_API_KEY not found in .env file");
    }
    # Optionally cache it into the current terminal session
    os.environ["GEMINI_API_KEY"] = api_key;  
    return api_key;
}

with entry{
    key = load_and_cache_api_key();
    print("API Key loaded and cached.");
}

glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

# Function for therapeutic dialogue with Aria
def therapeutic_session(user_input: str) -> str by llm(
    system_prompt="""
    # System Prompt: "Aria" - Your Personal Therapeutic Ally

    (Your entire therapeutic system prompt goes here exactly as you wrote it)
    """
);

node TherapyExchange {
    has user_message: str;
    has aria_reply: str = "";
}

walker TherapySessionWalker {
    has input_text: str;

    can run_session with `root entry {
        # Spawn a TherapyExchange node
        input_nodes = root ++> TherapyExchange(user_message=self.input_text);
        exchange = input_nodes[0];

        # Call LLM to generate a therapeutic response
        aria_response = therapeutic_session(exchange.user_message);
        exchange.aria_reply = aria_response;

        print("You:", exchange.user_message);
        print("Aria:", exchange.aria_reply);
    }
}

with entry:__main__ {
    # Example usage: user shares their feelings
    user_feeling = """
        I feel so overwhelmed right now, like I can't catch a break.
    """;

    # Run the therapeutic session
    root spawn TherapySessionWalker(input_text=user_feeling);
}