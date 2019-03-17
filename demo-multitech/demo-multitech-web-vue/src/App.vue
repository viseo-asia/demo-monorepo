<template>
  <div class="container" id="app">
    <h1>Demo Multi Tech v1</h1>

    <button v-on:click="refresh" type="button" class="btn btn-secondary">Refresh</button>

    <div class="row">
      <div class="col-sm-6 col-md-4 col-lg-3" v-for="petType in petTypes" :key="petType.name">
        <div class="card card-pet">
          <div class="card-body">
            <h5 class="card-title">{{ petType.name }}</h5>
            <p>{{ petType.message }}</p>
          </div>
        </div>
      </div>
    </div>

    <h6>Comments (From: {{ comments.origin }})</h6>

    <div class="input-group mb-3">
      <input
        v-model="commentInput"
        type="text"
        class="form-control"
        placeholder="New comment"
        aria-label="New comment"
        aria-describedby="button-addon2"
      >
      <div class="input-group-append">
        <button
          v-on:click="postComment"
          class="btn btn-outline-secondary"
          type="button"
          id="button-addon2"
        >Send</button>
      </div>
    </div>

    <div
      class="alert alert-secondary"
      role="alert"
      v-for="comment in comments.items"
      :key="comment.date"
    >
      {{ comment.text }}
      <br>
      <small>{{ new Date(comment.date).toLocaleString() }}</small>
    </div>
  </div>
</template>

<script>
const axios = require("axios");

export default {
  name: "app",
  components: {},
  data: function() {
    return {
      petTypes: [
        { type: "nodejs", name: "nodejs", message: "" },
        { type: "python", name: "python", message: "" },
        { type: "java", name: "java", message: "" },
        { type: "php", name: "php", message: "" },
        { type: "go", name: "go", message: "" }
      ],
      comments: {
        origin: "",
        items: []
      },
      commentInput: ""
    };
  },
  created: function() {
    this.refresh();
  },
  methods: {
    refresh: function() {
      for (var i = 0; i < this.petTypes.length; i++) {
        this.getPetInfo(i);
      }
      this.getComments();
    },
    getPetInfo: function(index) {
      axios
        .get(`/api-${this.petTypes[index].type}/`)
        .then(response => {
          this.petTypes[index].message = response.data;
        })
        .catch(() => {
          this.petTypes[index].message = "Error gettting content.";
        });
    },
    getComments: function() {
      axios
        .get(`/api-comments/`)
        .then(response => {
          this.comments = response.data;
        })
        .catch(() => {
          this.comments = { origin: "Error getting content", items: [] };
        });
    },
    postComment: async function() {
      const data = {
        text: this.commentInput
      };
      await axios.put(`/api-comments/`, data).catch(() => {
        this.comments = { origin: "Error getting content", items: [] };
      });
      this.commentInput = "";
      setTimeout(() => {
        this.getComments();
      }, 500);
    }
  }
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  color: #2c3e50;
  margin: 2rem;
}

.card-pet {
  margin: 0.5rem;
}

h1 {
  margin-bottom: 1rem;
}

h6 {
  margin-top: 1rem;
}
</style>
